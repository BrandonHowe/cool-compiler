//
// Created by Brandon Howe on 4/18/25.
//

#ifndef PROFILER_H
#define PROFILER_H

#pragma region Timer functions

#include <stdint.h>
#include <stdio.h>

#ifdef _WIN32
#include <intrin.h>
inline uint64_t ReadCPUTimer(void) {
    return __rdtsc();
}
#elif defined(__aarch64__)
inline __attribute__((always_inline)) uint64_t ReadCPUTimer(void) {
    uint64_t val;
    __asm__ volatile("isb;\n\tmrs %0, cntvct_el0" : "=r" (val) :: "memory");
    return val;
}
#elif defined(__x86_64__)
#include <x86intrin.h>
static inline uint64_t ReadCPUTimer(void) {
    return __rdtsc();
}
#else
#error "Unsupported architecture"
#endif

#if _WIN32

#include <x86intrin.h>
#include <intrin.h>
#include <windows.h>

static uint64_t GetOSTimerFreq(void)
{
	LARGE_INTEGER Freq;
	QueryPerformanceFrequency(&Freq);
	return Freq.QuadPart;
}

static uint64_t ReadOSTimer(void)
{
	LARGE_INTEGER Value;
	QueryPerformanceCounter(&Value);
	return Value.QuadPart;
}


static uint64_t EstimateCPUTimerFreq(void)
{
	uint64_t MillisecondsToWait = 100;
	uint64_t OSFreq = GetOSTimerFreq();

	uint64_t CPUStart = ReadCPUTimer();
	uint64_t OSStart = ReadOSTimer();
	uint64_t OSEnd = 0;
	uint64_t OSElapsed = 0;
	uint64_t OSWaitTime = OSFreq * MillisecondsToWait / 1000;
	while (OSElapsed < OSWaitTime)
	{
		OSEnd = ReadOSTimer();
		OSElapsed = OSEnd - OSStart;
	}

	uint64_t CPUEnd = ReadCPUTimer();
	uint64_t CPUElapsed = CPUEnd - CPUStart;

	uint64_t CPUFreq = 0;
	if (OSElapsed)
	{
		CPUFreq = OSFreq * CPUElapsed / OSElapsed;
	}

	return CPUFreq;
}

#else

#include <sys/time.h>

static uint64_t GetOSTimerFreq(void)
{
	return 1000000;
}

static uint64_t ReadOSTimer(void)
{
	// NOTE(casey): The "struct" keyword is not necessary here when compiling in C++,
	// but just in case anyone is using this file from C, I include it.
	struct timeval Value;
	gettimeofday(&Value, 0);

	uint64_t Result = GetOSTimerFreq() * (uint64_t)Value.tv_sec + (uint64_t)Value.tv_usec;
	return Result;
}

extern inline __attribute__((always_inline)) uint64_t EstimateCPUTimerFreq(void);

#endif

#pragma endregion

#pragma region Profiler implementation

typedef struct BHProfilerAnchor
{
	int64_t elapsed_exclusive; // not including childrens' runtimes
	int64_t elapsed_inclusive; // including childrens' runtimes
	const char* name;
	int64_t processed_byte_count;
	int16_t hit_count;
	int16_t line_num;
} BHProfilerAnchor;

typedef struct BHProfilerBlock
{
	int64_t start;
	int64_t end;
	int64_t old_elapsed_at_root;
	int16_t anchor_idx;
	int16_t parent_idx;
	int16_t line_num;
	const char* name;
} BHProfilerBlock;

typedef struct BHProfiler
{
	BHProfilerAnchor anchors[4096];
	int16_t parent;

	int64_t start;
	int64_t end;
} BHProfiler;

extern BHProfiler GlobalProfiler;

extern BHProfilerBlock BeginProfile(int64_t anchor_idx, int16_t line_num, int64_t byte_count, const char* name);
extern int64_t EndProfile(BHProfilerBlock block);
extern void InitProfiler(void);
extern void EndProfilerPrintProfile(void);

#define BH_PROFILER_ENABLED 0

#ifndef BH_PROFILER_ENABLED
#define BH_PROFILER_ENABLED 0
#endif

#if BH_PROFILER_ENABLED

#define NAME_CONCAT(X, Y) X##Y
#define START_PROFILER BHProfilerBlock profiler_block = BeginProfile(__COUNTER__ + 1, __LINE__, 0, __func__)
#define START_PROFILER_BANDWIDTH(byte_count) BHProfilerBlock profiler_block = BeginProfile(__COUNTER__ + 1, __LINE__, (byte_count), __func__)
#define END_PROFILER EndProfile(profiler_block)
#define PROFILE_BLOCK for (START_PROFILER; profiler_block.end == 0; profiler_block.end = END_PROFILER)
#define PROFILE_BANDWIDTH(byte_count) for (START_PROFILER_BANDWIDTH(byte_count); profiler_block.end == 0; profiler_block.end = END_PROFILER)

#else

#define NAME_CONCAT(...)
#define START_PROFILER
#define END_PROFILER
#define END_PROFILER_PRINT
#define PROFILE_BLOCK

#endif

#pragma endregion

#endif //PROFILER_H
