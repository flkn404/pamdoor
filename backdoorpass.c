
#include <stdlib.h> 
#include <stdio.h> 
#include <time.h>  
#define Size 14 
  
int main () 
{ 
    time_t t ; 
    struct tm *tmp ; 
    char PASSWORD[Size]; 
    time( &t ); 
      
    tmp = localtime( &t ); 
      
    // using strftime to generate one-minute password 
    strftime(PASSWORD, sizeof(PASSWORD), "%M%I%u%p%m%j%C", tmp); 
      
    printf("your password is : %s. it's only valid for 1 minute!\n", PASSWORD ); 
    return(0); 
} 
