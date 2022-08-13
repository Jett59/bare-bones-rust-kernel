use std::{process::Command, fs::canonicalize};

fn main() {
    println!("Building the assembly sources");
    let mut command = Command::new("make");
    command.current_dir(canonicalize("./asm-code").expect("Could not canonicalize ./asm-code"));
    command.output().expect("Failed to get output");
    let process = command.spawn().expect("Failed to compile assembly source");
    let exit_status = process.wait_with_output().expect("Failed to build").status;
    if exit_status.success() {
        println!("Built assembly sources");
    }else {
        println!("Failed to build assembly sources");
        panic!();
    }
}
