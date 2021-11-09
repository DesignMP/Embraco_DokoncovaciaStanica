export AS_SYSTEM_PATH := C:/BrAutomation/AS/System
export AS_BIN_PATH := C:/BrAutomation/AS410/bin-en
export AS_INSTALL_PATH := C:/BrAutomation/AS410
export AS_PATH := C:/BrAutomation/AS410
export AS_VC_PATH := C:/BrAutomation/AS410/AS/VC
export AS_GNU_INST_PATH := C:/BrAutomation/AS410/AS/gnuinst/V6.3.0
export AS_STATIC_ARCHIVES_PATH := D:/Projekty\ BER/Embraco_DokoncovaciaStanica/Temp/Archives/Config1/4PPC70_0702_20B
export AS_CPU_PATH := D:/Projekty\ BER/Embraco_DokoncovaciaStanica/Temp/Objects/Config1/4PPC70_0702_20B
export AS_CPU_PATH_2 := D:/Projekty BER/Embraco_DokoncovaciaStanica/Temp/Objects/Config1/4PPC70_0702_20B
export AS_TEMP_PATH := D:/Projekty\ BER/Embraco_DokoncovaciaStanica/Temp
export AS_BINARIES_PATH := D:/Projekty\ BER/Embraco_DokoncovaciaStanica/Binaries
export AS_PROJECT_CPU_PATH := D:/Projekty\ BER/Embraco_DokoncovaciaStanica/Physical/Config1/4PPC70_0702_20B
export AS_PROJECT_CONFIG_PATH := D:/Projekty\ BER/Embraco_DokoncovaciaStanica/Physical/Config1
export AS_PROJECT_PATH := D:/Projekty\ BER/Embraco_DokoncovaciaStanica
export AS_PROJECT_NAME := Embraco_LinkaNaOdlievanieRotorov_DokoncovaciaStanica_Rev2
export AS_PLC := 4PPC70_0702_20B
export AS_TEMP_PLC := 4PPC70_0702_20B
export AS_USER_NAME := Martin\ Dvorscak
export AS_CONFIGURATION := Config1
export AS_COMPANY_NAME := \ 
export AS_VERSION := 4.10.3.60\ SP
export AS_WORKINGVERSION := 4.10


default: \
	$(AS_CPU_PATH)/Visu.br \



include $(AS_CPU_PATH)/Visu/Visu.mak
