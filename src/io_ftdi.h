
enum io_outputs_state { IDLE=0, WORK };

void io_close(void);
int io_set_outputs(enum io_outputs_state outstate, int verbosity);
int io_init(int vendor, int product, const char* serial, unsigned int index, unsigned int interface, unsigned long frequency, int verbosity);
int io_scan(const unsigned char *TMS, const unsigned char *TDI, unsigned char *TDO, int bits);
int io_set_period(unsigned int period);
