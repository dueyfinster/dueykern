/*
* kernel.c
*/

void kmain(void){
  const char *str = "duey kernel is alive!";
  char *vidptr = (char*)0xb8000; // Video memory begins at this address
  unsigned int i = 0;
  unsigned int j = 0;

  /* Loop to clear the screen,
   * 80*25 is terminal size,
   * each element is 2 bytes
   */
  while(j<80*25*2){
    /* blank charachter */
    vidptr[j] = ' ';
    /* set attribute byte, defines color */
    vidptr[j+1] = 0x07; // light gray on black
    j = j+2;
  }

  j = 0;

  while(str[j] != '\0'){
    vidptr[i] = str[j]; // assign char ascii to memory after video memory
    vidptr[i+1] = 0x07; // give char black background & light grey colour
    ++j; // move on to next char
    i = i+2; // set memory location of next colour
  }

  return;
}


/*
 * Different colours:
 * 0 - Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red, 5 - Magenta, 
 * 6 - Brown, 7 - Light Grey, 8 - Dark Grey, 9 - Light Blue, 
 * 10/a - Light Green, 11/b - Light Cyan, 12/c - Light Red, 
 * 13/d - Light Magenta, 14/e - Light Brown, 15/f – White.
 */

