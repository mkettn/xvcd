void io_close(void);
int io_init(int product, int vendor, int verbosity);
int io_scan(const unsigned char *TMS, const unsigned char *TDI, unsigned char *TDO, int bits);
