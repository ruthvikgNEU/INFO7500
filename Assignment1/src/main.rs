extern crate hex;
extern crate sha2;
extern crate rand;

use hex::encode;
use sha2::{Digest, Sha256};
use rand::Rng;

fn main() {
    let id_hex = "ED00AF5F774E4135E7746419FEB65DE8AE17D6950C95CEC3891070FBB5B03C78";
    let id_bytes = hex::decode(id_hex).expect("Failed to decode target");

    let search_byte = 0x2F;
    let mut rng = rand::thread_rng();
    let mut result_bytes: Vec<u8>;

    loop {
        result_bytes = (0..32).map(|_| rng.gen()).collect();

        let mut result = result_bytes.clone();
        result.extend_from_slice(&id_bytes);

        let hash = Sha256::digest(&result);

        if hash.iter().any(|&byte| byte == search_byte) {
            let random_hex = encode(&result_bytes);
            println!("Found random bytes: {}", random_hex);
            break;
}
}
}