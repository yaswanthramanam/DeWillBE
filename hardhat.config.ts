import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
// import dotenv from "dotenv";

// dotenv.config(); // Load environment variables from .env file

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  // networks: {
  //   sonicblaze: {
  //     url: "https://rpc.blaze.soniclabs.com",
  //     chainId: 57054,
  //     accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
  //   },
  // },
};

export default config;
