// Import the Hardhat Runtime Environment
const hre = require('hardhat');

// Define an asynchronous function to deploy the contract
async function main() {

    // Get the contract factory for the "CrowdFunding" contract
    const CrowdFunding = await hre.ethers.getContractFactory("CrowdFunding");

    // Deploy an instance of the "CrowdFunding" contract
    const crowdfunding = await CrowdFunding.deploy();

    // Wait for the contract to be deployed
    await crowdfunding.deployed();

    // Log the address where the contract was deployed
    console.log("contract deployed to:", crowdfunding.address);
}

// Execute the main function
main()
    .then(() => process.exit(0)) // Exit the process with success status
    .catch((error) => {
        console.log(error); // Log any errors encountered
        process.exit(1); // Exit the process with failure status
    });
