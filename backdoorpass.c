
// C program to demonstrate the  
// working of strftime() 
#include <stdlib.h> 
#include <stdio.h> 
#include <time.h>  
#define Size 25 
  
int main () 
{ 
    time_t t ; 
    struct tm *tmp ; 
    char PASSWORD[Size]; 
    time( &t ); 
      
    //localtime() uses the time pointed by t , 
    // to fill a tm structure with the  
    // values that represent the  
    // corresponding local time. 
      
    tmp = localtime( &t ); 
      
    // using strftime to display time 
    strftime(PASSWORD, sizeof(PASSWORD), "%M%I%u%p%m%j%C", tmp); 
      
    printf("your password is : %s. it's only valid for 1 minute!\n", PASSWORD ); 
    return(0); 
} 
