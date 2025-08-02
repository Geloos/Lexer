This is a lexical analyzer (lexer) for a custom variant of the C++ language, built using Flex.

Features:

  Token Recognition: Identifies standard keywords, identifiers, and various types of constants.
  
  Symbol Table: Implemented in C to store every token encountered and return its index.
  
  Custom Tokens: Includes rules for special token types.
  
  Error Handling: When an unrecognized character is found, the lexer prints the invalid character and the entire line where it occurred. It then discards the character and continues scanning for the next valid token.
  
  Debugging: Can be compiled with a DEBUGSSC flag to print detailed token information during processing.

To run:
   
   1)You need to install flex 
    sudo apt update && sudo apt install flex -y
   
   2)git clone https://github.com/Geloos/Lexer.git

   3)cd lexer

   4)make

   5)./scc_main test.txt

   ENJOY :D
    
