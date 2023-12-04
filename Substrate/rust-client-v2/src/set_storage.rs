#[macro_use]
extern crate clap;

use clap::App;
#[allow(unused_imports)]
use node_template_runtime::{
    pallet_sim_renault_accident::Call as PalletSimRenaultAccidentCall, Runtime, RuntimeCall,
};
// use sp_core::crypto::Pair;
// use sp_core::sr25519;
use sp_keyring::AccountKeyring;
#[allow(unused_imports)]
use substrate_api_client::{
    ac_primitives::{PlainTipExtrinsicParams, ExtrinsicSigner, SubstrateKitchensinkConfig}, rpc::WsRpcClient, Api, SubmitAndWatch, XtStatus, 
};

fn main() {
    println!("Start program");
    env_logger::init();
    let url = get_node_url_from_cli();

    println!("Start set_storage");
    let from = AccountKeyring::Alice.pair();
    let client = WsRpcClient::new(&url).unwrap();
    // let genesis_hash = client.genesis_hash().unwrap();
    // let metadata = client.metadata().unwrap();
    // let runtime_version = client.runtime_version().unwrap();
    // let mut api = Api::new_offline(genesis_hash, metadata, runtime_version, client);
    // let mut api = Api::<PlainTipExtrinsicParams<node_template_runtime::Runtime>, WsRpcClient>::new(client).unwrap();
    let mut api = Api::<SubstrateKitchensinkConfig, _>::new(client).unwrap();

    api.set_signer(ExtrinsicSigner::<SubstrateKitchensinkConfig>::new(from));
    // api.set_signer(from);

    // let api = init_api.unwrap();
    println!("end init set_storage");

    let key = "foo"; //0x666F6F
    let value: &str = "bar"; //0x626172
    println!(
        "Set key: {:X?} <=> {:X?}",
        key.clone(),
        key.clone().as_bytes().to_vec()
    );
    println!(
        "Set value: {:X?} <=> {:X?}",
        value.clone(),
        value.clone().as_bytes().to_vec()
    );

    // let res = set_storage_value(
    //     api.clone(),
    //     key.clone().as_bytes().to_vec(),
    //     val.clone().as_bytes().to_vec(),
    // );
    let data_hash = [0u8; 36];
    let nonce: u32 = api.get_nonce().unwrap();
    println!("Create extrinsic");
    // let xt = api.compose_extrinsic_offline(RuntimeCall::PalletSimRenaultAccident(PalletSimRenaultAccidentCall::report_accident { data_hash: data_hash }));
    let xt = api.compose_extrinsic_offline(
        RuntimeCall::PalletSimRenaultAccident(PalletSimRenaultAccidentCall::report_accident {
            data_hash: data_hash,
        }),
        nonce,
    );
    println!("End create extrinsic");
    println!("Send Tx"); // Submit and watch the extrinsic until it reaches the desired status
                         // match api.submit_and_watch_extrinsic_until(xt, XtStatus::InBlock) {
                         //     Ok(report) => {
                         //         println!("[+] Transaction got included in block {:?}", report.block_hash);
                         //         // Additional handling based on the report can be added here
                         //     },
                         //     Err(e) => eprintln!("ERROR: {:?}", e),
                         // }
    match SubmitAndWatch::submit_and_watch_extrinsic_until(&api, xt, XtStatus::InBlock) {
        Ok(report) => {
            println!(
                "[+] Transaction got included in block {:?}",
                report.block_hash
            );
            // Additional handling based on the report can be added here
        }
        Err(e) => eprintln!("ERROR: {:?}", e),
    }

    println!("End send Tx");

    // let res2 = SubmitAndWatch
    // let res = api.send_extrinsic(xt.hex_encode(), XtStatus::InBlock);
    // println!("End send Tx");
    // match res {
    //     Err(e) => eprintln!("ERROR: {}", e),
    //     Ok(blockh) => println!("[+] Transaction got included in block {:?}", blockh),
    // }
}

/// Set storage data value with a given key
/// # Arguments
/// * `api` - Api endpoint
/// * `key` - Storage key
/// * `value` - Storage value
// fn set_storage_value(
//     mut api: Api<sr25519::Pair, Result<WsRpcClient, Error>>,
//     key: Vec<u8>,
//     value: Vec<u8>,
// ) -> Result<Option<H256>, substrate_api_client::Error> {
//     // set the storage
//     // define the recipient
//     println!("Create extrinsic");
//     let xt = api.compose_extrinsic_offline(api.clone(), "KeyvalueModule", "store", key, value);
//     println!("End create extrinsic");
//     println!("Send Tx");
//     api.send_extrinsic(xt.hex_encode(), XtStatus::InBlock)
// }

pub fn get_node_url_from_cli() -> String {
    let yml = load_yaml!("../src/cli.yml");
    let matches = App::from_yaml(yml).get_matches();

    let node_ip = matches
        .value_of("node-server")
        .unwrap_or("ws://10.212.115.235");
    let node_port = matches.value_of("node-port").unwrap_or("9944");
    let url = format!("{}:{}", node_ip, node_port);
    println!("Interacting with node on {}", url);
    url
}
