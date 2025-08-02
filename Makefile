# Compiler and flags
CC = gcc
CFLAGS = -Wall -g -DDEBUGSSC

# Source files and target executable
TARGET = scc_main
GEN_LEX_C = lex.yy.c
LEX_SRC = ssc.l

all: $(TARGET)

$(TARGET): $(GEN_LEX_C)
	$(CC) $(CFLAGS) -o $(TARGET) $(GEN_LEX_C)


$(GEN_LEX_C): $(LEX_SRC)
	flex -o $(GEN_LEX_C) $(LEX_SRC)

clean:
	rm -f $(TARGET) $(GEN_LEX_C) *.o

