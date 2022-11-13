#include <stdlib.h>
#include <stdio.h>
#include <papi.h>

char eventLabel[PAPI_MAX_STR_LEN];

void initPapi()
{
    int papiResponse;
    if ((papiResponse = PAPI_library_init(PAPI_VER_CURRENT)) != PAPI_VER_CURRENT)
    {
        printf("Error : PAPI Library initialization error! \n");
        exit(1);
    }
}

void createEventSet(int *eventSet)
{
    int papiResponse;
    if ((papiResponse = PAPI_create_eventset(eventSet)) != PAPI_OK)
    {
        printf("Error : PAPI failed to create the Eventset\n");
        printf("Error string : %s  :: Error code : %d \n", PAPI_strerror(papiResponse), papiResponse);
        exit(1);
    }
}

void addEvent(int eventSet, int event)
{
    int papiResponse;

    if ((papiResponse = PAPI_add_event(eventSet, event)) != PAPI_OK)
    {
        PAPI_event_code_to_name(event, eventLabel);
        printf("Error : PAPI failed to add event %s\n", eventLabel);
        printf("Error string : %s  :: Error code : %d \n", PAPI_strerror(papiResponse), papiResponse);
        exit(1);
    }
}

void startMeasure(int eventSet)
{
    int papiResponse;
    if ((papiResponse = PAPI_start(eventSet)) != PAPI_OK)
    {
        fprintf(stderr, "PAPI failed to start counters: %s\n", PAPI_strerror(papiResponse));
        exit(1);
    }
}

long_long stopMeasure(int eventSet)
{
    int papiResponse;
    long_long value = -1;

    if ((papiResponse = PAPI_stop(eventSet, &value)) != PAPI_OK)
    {
        fprintf(stderr, "PAPI failed to read counters: %s\n", PAPI_strerror(papiResponse));
        exit(1);
    }

    return value;
}

int createEmptyEventSet()
{
    return PAPI_NULL;
}

int getEvent(int type)
{
    return type == 0 ? PAPI_L2_DCM : PAPI_TOT_INS;
}

char *getEventLabel(int type)
{
    return type == 0 ? "cache-misses" : "total-instructions";
}

void initAndMeasure(int *eventSet, int event)
{
    initPapi();
    createEventSet(eventSet);
    addEvent(*eventSet, event);
    startMeasure(*eventSet);
}