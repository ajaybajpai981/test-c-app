# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -I.

# Target executable
TARGET = hello

# Source files
SRCS = hello.c submodules/math_utils/math_utils.c
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET) $(TARGET).exe

.PHONY: all clean
