%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
extern FILE *yyin;

typedef struct Passenger {
    char *given_name;
    char *surname;
} Passenger;

typedef struct Flight {
    char *flight_number;
    Passenger *passengers;
    int num_passengers;
} Flight;

Flight *current_flight;

%}

%union {
    char *str_val;
    int num_val;
    Passenger *passenger_val;
    Flight *flight_val;
}

%token OPEN_TAG CLOSE_TAG ATTRIBUTE IDENTIFIER VALUE UNKNOWN
%token <str_val> IDENTIFIER
%token <str_val> VALUE

%%

program:
    | program flight
    ;

flight:
    OPEN_TAG "Flight" ATTRIBUTE VALUE CLOSE_TAG passengers
    {
        current_flight = (Flight *)malloc(sizeof(Flight));
        current_flight->flight_number = strdup($3);
        current_flight->num_passengers = $5;
        current_flight->passengers = $6;
        printf("Flight number: %s\n", current_flight->flight_number);
    }
    ;

passengers:
    OPEN_TAG "Passenger" ATTRIBUTE VALUE CLOSE_TAG passenger_list
    {
        printf("Passengers for flight %s:\n", current_flight->flight_number);
        for (int i = 0; i < current_flight->num_passengers; ++i) {
            printf("%s %s\n", current_flight->passengers[i].given_name, current_flight->passengers[i].surname);
        }
    }
    ;

passenger_list:
    passenger
    | passenger_list passenger
    ;

passenger:
    OPEN_TAG "GivenName" VALUE CLOSE_TAG
    {
        Passenger new_passenger;
        new_passenger.given_name = strdup($3);
        printf("Passenger given name: %s\n", new_passenger.given_name);
    }
    OPEN_TAG "Surname" VALUE CLOSE_TAG
    {
        new_passenger.surname = strdup($3);
        printf("Passenger surname: %s\n", new_passenger.surname);
    }
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return 1;
        }
    }

    if (!yyparse()) {
        printf("SUCCESS\n");
    } else {
        printf("ERROR\n");
    }

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "ERROR: %s\n", s);
    exit(1);
}

