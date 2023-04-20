with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Command_Line;    use Ada.Command_Line;
procedure pals is

   --return true if a given character is alphabetic and false if not
   function isAlphabetic (C : Character) return Boolean is
   begin
      --Alphabetic range
      return (C >= 'a' and C <= 'z') or (C >= 'A' and C <= 'Z');
   end isAlphabetic;

   --from input string return the string of upper case
   function toUpperCase (Input : String) return String is
      Copy : String := Input;
   begin
      for I of Copy loop
         if isAlphabetic (I) and I >= 'a' and I <= 'z' then
            I := Character'Val (Character'Pos (I) - 32);
         end if;
      end loop;
      return Copy;
   end toUpperCase;

   --Takes a string and remove all non alphabetic characters
   function makeAlphabetic (Input : String) return String is
      CountAlphabetic : Integer := 0;
   begin
      --count alphabetic letters
      for I of Input loop
         if isAlphabetic (I) then
            CountAlphabetic := CountAlphabetic + 1;
         end if;
      end loop;
      --create new string
      declare
         NewString : String (1 .. CountAlphabetic);
         Index     : Integer := NewString'First;
      begin
         for I of Input loop
            if isAlphabetic (I) then
               NewString (Index) := I;
               Index             := Index + 1;
            end if;
         end loop;
         return NewString;
      end;
   end makeAlphabetic;

   --A function that determines if a given character is a palindrome or not
   --returns a boolean
   function isPalindrome (Input : String) return Boolean is
      isPalindrome : Boolean := True;
      Begining     : Integer := Input'First;
      Ending       : Integer := Input'Last;
   begin
      --double pointer begining to middle check
      while Begining <= Ending and isPalindrome loop
         isPalindrome := Input (Begining) = Input (Ending);
         Begining     := Begining + 1;
         Ending       := Ending - 1;
      end loop;
      return isPalindrome;
   end isPalindrome;

   --A procedure that given a string does the work associated with
   --the palindrome status and prints to standard out
   procedure Process_Line (Input : String) is
   begin
      --input
      Put ("String: ");
      Put_Line (Input);

      --find status
      Put ("Status: ");
      if isPalindrome (Input) then
         --is palindrome
         Put_Line ("Palindrome as entered");
      else
         
         if isPalindrome (makeAlphabetic (Input)) then
            
            Put_Line ("Palindrome when non-letters are removed");
         elsif isPalindrome (toUpperCase (Input)) then
            
            Put_Line ("Palindrome when converted to upper case");
         elsif isPalindrome (makeAlphabetic (toUpperCase (Input))) then
            
            Put_Line
              ("Palindrome when non-letters are removed and converted to upper case");
         else
            
            Put_Line ("Not a palindrome");
         end if;

      end if;

      New_Line;
   end Process_Line;

begin
   --if there are no arguments then take from standard in
   if Argument_Count = 0 then
      while not End_Of_File loop
         declare
            Input : String := Get_Line;
         begin
            Process_Line (Input);
         end;
      end loop;
   else
      --if there are arguments then take from the given file
      declare
         Input_File : File_Type;

      begin
         Open
           (File => Input_File, Mode => Ada.Text_IO.In_File,
            Name => Argument (1));
         while not End_Of_File (Input_File) loop
            declare
               Input : String := Get_Line (File => Input_File);
            begin
               Process_Line (Input);
            end;
         end loop;
      end;
   end if;

exception
   --if the given file does not exist
   when Name_Error =>
      Put ("Please enter a valid FileName!");
end pals;
