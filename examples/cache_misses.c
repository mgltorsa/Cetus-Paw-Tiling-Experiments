#include <stdlib.h>
#include <stdio.h>
#include <papi.h>

int events[] = {PAPI_TOT_CYC};
long_long values[] = {0};
char eventLabel[PAPI_MAX_STR_LEN];

void initPapi()
{
    int papiResponse;
    if ((papiResponse = PAPI_library_init(PAPI_VER_CURRENT)) != PAPI_VER_CURRENT)
    {
        printf("\n\t  Error : PAPI Library initialization error! \n");
        return (-1);
    }
}

void createEventSet(int *eventSet)
{
    int papiResponse;
    if ((papiResponse = PAPI_create_eventset(eventSet)) != PAPI_OK)
    {
        printf("\n\t  Error : PAPI failed to create the Eventset\n");
        printf("\n\t  Error string : %s  :: Error code : %d \n", PAPI_strerror(retval), retval);
        return (-1);
    }
}

void addEvent(int eventSet, int event)
{
    if ((papiResponse = PAPI_add_event(eventSet, event)) != PAPI_OK)
    {
        PAPI_event_code_to_name(events, eventLabel);
        printf("\n\t   Error : PAPI failed to add event %s\n", eventLabel);
        printf("\n\t   Error string : %s  :: Error code : %d \n", PAPI_strerror(retval), retval);
    }
}

void startMeasure(int eventSet)
{
    int papiResponse;
    if ((papiResponse = PAPI_start(EventSet)) != PAPI_OK)
    {
        fprintf(stderr, "PAPI failed to start counters: %s\n", PAPI_strerror(retval));
        exit(1);
    }
}

long_long stopMeasure(int eventSet)
{
    int papiResponse;
    long_long value=-1;

    if ((papiResponse = PAPI_stop(eventSet, &value)) != PAPI_OK)
    {
        fprintf(stderr, "PAPI failed to read counters: %s\n", PAPI_strerror(retval));
        exit(1);
    }

    return value;
}

int main(int argc, char const *argv[])
{

    return 0;
}
