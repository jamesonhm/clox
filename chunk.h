#ifndef clox_chunk_h
#define clox_chunk_h

#include "common.h"

typedef enum {
    OP_RETURN, //return from the current function
} OpCode;

// This is a dynamic array...?
// count is the number of entries in use
// capacity is the number of elements allocated
typedef struct {
    int count;
    int capacity;
    uint8_t* code;
} Chunk;

void initChunk(Chunk* chunk);

#endif 

