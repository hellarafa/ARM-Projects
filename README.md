# ARM Assembly

If you haven't noticed, ARM processors are everywhere. If you look around you, there are probably more ARM CPU's than there are Intel CPU's. They are used in many IoT devices and due to their relatively inexpensive cost, their usage and importance will only increase.

To get started, I suggest you purchase a Raspberry Pi and start from there. I'm sorry but if you do not know what a Raspberry Pi is, then you got a long educational journey ahead of you, but don't get discouraged! Any Raspberry Pi will do, as long as you can either SSH into it or have some kind of terminal/command prompt to interact with. If you don't have a Raspberry Pi, then you can also emulate one with QEMU.

Currently, at the time of writing this, I have a root shell on a home router that is manufactured by the company I work for, and it uses an ARM7L CPU. The only downside to using this, is that I have to install the Cross Compilation ARM utilities onto an Ubuntu VM, assemble and link the code in the VM, then SCP the binaries over to the router to execute them. I've included a small section below with some steps to get started using this method. Honestly, as long as you have some type of hardware that you have access to and can run privileged code, then you can use whatever you'd like. But I honestly recommend sticking with a Raspberry Pi.

## Getting Started with a Raspberry Pi
*Coming Soon...*

## Getting Started with a Different Hardware Platform.
### Linux Cross-Compilation to ARM.
**NOTE: The libraries are platform dependant. Because I am using a home router, and it has an ARM7L CPU, then I'll be installing the specific architecture libraries listed below. I've also included the C/C++ libraries to help with the C/C++ to ARM disassembly**

First, install the GCC, G++ and utilities for the ARMEL Platform:
`sudo apt-get install g++-arm-linux-gnueabi gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi libncurses5-dev libc6-armel-cross`

If you have the ARMHF Platform:
`sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf binutils-arm-linux-gnueabihf libncurses5-dev libc6-armhf-cross`

A link to a reference I used to help me get started can be found [here][1]. I don't have an ACME board but the process is completely the same.

# References
* [Azeria Labs: Intro to ARM Assembly Basics](https://azeria-labs.com/writing-arm-assembly-part-1/)
* [Thinkingeek: ARM Assembly with the Raspberry Pi](https://thinkingeek.com/2013/01/09/arm-assembler-raspberry-pi-chapter-1/)
* [Microdigital: ARM Assembly with the Raspberry Pi](http://www.microdigitaled.com/ARM/ASM_ARM/Software/ARM_Assembly_Programming_Using_Raspberry_Pi_GUI.pdf)
* [Smith.edu: ARM Assembly with the Raspberry Pi](http://www.science.smith.edu/dftwiki/index.php/Tutorial:_Assembly_Language_with_the_Raspberry_Pi#Assemble.2C_Compile.2C_and_Run.21)
* [Coranac: Whirlwind Tour of ARM](https://www.coranac.com/tonc/text/asm.htm)
* [RaspberryPi: Learning ARM Assembly](https://www.raspberrypi.org/forums/viewtopic.php?t=22820)
* [Davespace: Introduction to ARM](http://www.davespace.co.uk/arm/introduction-to-arm/)

[1]: https://www.acmesystems.it/arm9_toolchain
