const { ApiPromise, WsProvider, Keyring } = require('@polkadot/api');

async function sendReportAccidentExtrinsic() {
  // Connect to the local node
//   const provider = new WsProvider('ws://localhost:9944');
  const provider = new WsProvider('ws://substrate-ws.unice.cust.tasfrance.com/');
  const api = await ApiPromise.create({ provider });

  // Create a keyring instance for sending transactions
  const keyring = new Keyring({ type: 'sr25519' });

  // Replace 'Alice' with the account that you want to use to send the extrinsic
  const alice = keyring.addFromUri('//Alice');

  // Define the dummy data hash (all "1"s)
  const dummyDataHash = "0x010101010101010101010101010101010101010101010101010101010101010101010101"

  try {
    // Send the extrinsic to report the accident
    const tx = api.tx.palletSimRenaultAccident.reportAccident(dummyDataHash);
    const txHash = await tx.signAndSend(alice);

    console.log(`Extrinsic sent with hash: ${txHash}`);
  } catch (error) {
    console.error('Error sending extrinsic:', error);
  }

  // Disconnect from the node
  await provider.disconnect();
}

sendReportAccidentExtrinsic();
