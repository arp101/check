/**************************HEADERS********************************************/

/**************************CONSTANTS******************************************/
#define TRUE         1    
#define FALSE        0 
#define BLOCKSIZE    256
#define FILENAMESIZE 56
#define TIMELENGTH   100
#define LINK_MAX     10
#define FILENAME "savedFS.txt"
/**************************STRUCTS--DECLARATIONS******************************/
typedef struct BlockPointerTable{
 int fileSize;                            //size of file
 char modifiedDateTime[TIMELENGTH];       //When last modified
 int dataBlockPointer;                    //index to dataBlock
 char permissionCode[3];                  //Permission for the File
 struct BlockPointerTable extentPointer; //incase of bigger files point to another file
}BlockPointerTable;

typedef struct FileNameTable{
  char fileName[FILENAMESIZE];           //name of file being stored
  BlockPointerTable iNode;       //iNode Pointer
}FileNameTable;

struct Link{
  char linkName[FILENAMESIZE];
  BlockPointerTable *linkedFile;
}Link;



struct FileSystem{
 char fileSystemName[FILENAMESIZE];       //Name of File System
 int numBlocks;                           //Number of Data blocks in System
 int numABPT;                             //Keep track of ABPT blocks avail
 int numFNT;                              //Keep track of FNT blocks avail
 int *FNTMap;                             //Maps available data slot for FNT
 int *ABPTMap;                            //Maps available data slot for ABPT
 int *dataBlockMap;                       //Maps available data slot for datablock CPM style 1 fiel 1 block
 struct FileNameTable *files;             //Structure for holding initial files
 struct BlockPointerTable *pointerTables;
 char **dataBlocks;                       //Data block for holding all info
 struct Link link[LINK_MAX];              //arritibtrary size of 10 links max
}FileSystem;

void menu();
void createFileSystem( int numBlocks);
void formatFileSystem(char name[FILENAMESIZE],int numPointerEntries,int numFNT);
void saveFileSystem(char *nameOfSave);
void openFileSystem(char *nameOfSave);
void listFiles();
void removeFile(char *nameOfFile);
void putFile(char *nameOfFile);
int buildFile(char* fileName);
int  findNextFreeSlot(int* arraySearch,int sizeOfArr);
int  freeBlocks(int* arraySearch,int sizeOfArr);
void updateSlot(int* arraySearch,int valChange, int index);
void listFilesInDir();
int getFileSize(const char *fileName);
char * getModDate(char* fileName);
void getFile(char *nameOfFile);
void createLink(char *shortCutName, char *nameOfFile);
void removeLink(char *shortCutName);
void changePermission(char *permissionCode, char *fileName);

