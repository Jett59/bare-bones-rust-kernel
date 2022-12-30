#![no_std]
#![no_main]

#[cfg(target_arch = "x86_64")]
mod x86_64;
#[cfg(target_arch = "x86_64")]
use x86_64::arch_api;

use core::panic::PanicInfo;

#[panic_handler]
fn kpanic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
extern "C" fn kmain() -> ! {
    arch_api::console::clear();
    arch_api::console::write_string("Hello, World!");
    unsafe {
        // Print whether we are in the higher half.
        let mut address: usize;
        // We can lea using rip-relative addressing.
        // Also use the att_syntax feature to get the syntax we want.
        core::arch::asm!("lea 0(%rip), {}", out(reg) address, options(att_syntax));
        if address > 0xffff800000000000 {
            arch_api::console::write_string("We are in the higher half!");
        } else {
            arch_api::console::write_string("We are in the lower half!");
        }
    }
    loop {}
}
