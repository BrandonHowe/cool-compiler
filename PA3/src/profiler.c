//
// Created by Brandon Howe on 4/18/25.
//

#include "profiler.h"

#if _WIN32
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
#elif defined(__aarch64__)
extern inline __attribute__((always_inline)) uint64_t EstimateCPUTimerFreq(void) {
	uint64_t val;
	__asm__ volatile("mrs %0, cntfrq_el0" : "=r" (val));
	return val;
}
#elif defined(__x86_64__)

#include <stdint.h>
#include <time.h>

extern inline __attribute__((always_inline)) uint64_t EstimateCPUTimerFreq(void) {
    struct timespec start_ts, end_ts;
    uint64_t start, end;

    clock_gettime(CLOCK_MONOTONIC_RAW, &start_ts);
    start = __rdtsc();

    struct timespec delay = {.tv_sec = 0, .tv_nsec = 100000000}; // 100ms
    nanosleep(&delay, NULL);

    end = __rdtsc();
    clock_gettime(CLOCK_MONOTONIC_RAW, &end_ts);

    uint64_t elapsed_ns = (end_ts.tv_sec - start_ts.tv_sec) * 1000000000ULL +
                          (end_ts.tv_nsec - start_ts.tv_nsec);
    return ((end - start) * 1000000000ULL) / elapsed_ns;
}

#else
#error "Unsupported architecture"
#endif

extern BHProfiler GlobalProfiler = { 0 };

extern BHProfilerBlock BeginProfile(int64_t anchor_idx, int16_t line_num, int64_t byte_count, const char* name)
{
	BHProfilerAnchor existing_anchor = GlobalProfiler.anchors[anchor_idx];
	GlobalProfiler.anchors[anchor_idx].processed_byte_count += byte_count;
	BHProfilerBlock profiler_block = (BHProfilerBlock){
		.anchor_idx = anchor_idx,
		.parent_idx = GlobalProfiler.parent,
		.name = name,
		.line_num = line_num,
		.end = 0,
		.old_elapsed_at_root = existing_anchor.elapsed_inclusive
	};
	GlobalProfiler.parent = anchor_idx;
	profiler_block.start = ReadCPUTimer();
	return profiler_block;
}

extern int64_t EndProfile(BHProfilerBlock block)
{
	uint64_t time = ReadCPUTimer();
	block.end = time;
	int64_t elapsed = block.end - block.start;
	GlobalProfiler.anchors[block.anchor_idx].elapsed_exclusive += elapsed;
	GlobalProfiler.anchors[block.parent_idx].elapsed_exclusive -= elapsed;
	GlobalProfiler.anchors[block.anchor_idx].elapsed_inclusive = block.old_elapsed_at_root + elapsed;
	GlobalProfiler.anchors[block.anchor_idx].name = block.name;
	GlobalProfiler.anchors[block.anchor_idx].line_num = block.line_num;
	GlobalProfiler.anchors[block.anchor_idx].hit_count += 1;
	GlobalProfiler.parent = block.parent_idx;
	return block.end;
}

extern void InitProfiler(void)
{
	if (!BH_PROFILER_ENABLED) return;
	GlobalProfiler.start = ReadCPUTimer();
}

extern void EndProfilerPrintProfile(void)
{
	if (!BH_PROFILER_ENABLED) return;
	GlobalProfiler.end = ReadCPUTimer();

	uint64_t CPUFreq = EstimateCPUTimerFreq();
	uint64_t TotalCPUElapsed = GlobalProfiler.end - GlobalProfiler.start;

	if (CPUFreq)
	{
		printf("\nTotal time: %0.4fms (CPU freq %llu)\n", 1000.0 * (double)TotalCPUElapsed / (double)CPUFreq, CPUFreq);
	}

	for (int i = 1; i < 4096; i++)
	{
		BHProfilerAnchor anchor = GlobalProfiler.anchors[i];
		if (anchor.elapsed_inclusive <= 0) continue;
		double percentage = (double)anchor.elapsed_exclusive / (double)TotalCPUElapsed * 100;
		printf("%s_%i[%i]: %llu (%.2f%%", anchor.name, anchor.line_num, anchor.hit_count, anchor.elapsed_exclusive, percentage);
		if (anchor.elapsed_inclusive != anchor.elapsed_exclusive)
		{
			double percentage_with_children = anchor.elapsed_inclusive / (double)TotalCPUElapsed * 100;
			printf(", %.2f%% with children", percentage_with_children);
		}
		printf(")");

		if (anchor.processed_byte_count)
		{
			double mb = 1024.0 * 1024.0;
			double gb = mb * 1024.0;

			double seconds = (double)anchor.elapsed_inclusive / CPUFreq;
			double bytes_per_second = (double)anchor.processed_byte_count / seconds;
			double mbps = (double)anchor.processed_byte_count / mb;
			double gbps = bytes_per_second / gb;

			printf(" - %.3fmb at %.2fgb/s", mbps, gbps);
		}
		printf("\n");
	}
}
