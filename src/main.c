#include <stdio.h>

#include "chunk.h"
// #include "common.h"
#include "debug.h"

int main(int argc, const char* argv[]) {
    Chunk chunk;
    initChunk(&chunk);

    int constant = addConstant(&chunk, 1.2);
    writeChunk(&chunk, OP_CONSTANT);
    writeChunk(&chunk, constant);

    writeChunk(&chunk, OP_RETURN);
    printf("chunk written\n");

    disassembleChunk(&chunk, "test chunk");
    freeChunk(&chunk);
    printf("chunk freed\n");
    return 0;
}

