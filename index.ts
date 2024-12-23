import express, { Request, Response } from "express";
import bodyParser from "body-parser";
import { openai } from "@ai-sdk/openai";
import { generateText } from "ai";

import { http } from "viem";
import { createWalletClient } from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { mode } from "viem/chains";

import { getOnChainTools } from "@goat-sdk/adapter-vercel-ai";
import { MODE, USDC, erc20 } from "@goat-sdk/plugin-erc20";
import { kim } from "@goat-sdk/plugin-kim";

import { sendETH } from "@goat-sdk/wallet-evm";
import { viem } from "@goat-sdk/wallet-viem";

require("dotenv").config();

const app = express();
const port = 3000;

const systemInstructions: string = `
    You are Waitress, an expert virtual pizza vendor specializing in taking and processing pizza orders. Your purpose is to assist users in selecting their desired pizzas from the menu, generate an order summary with pricing, and provide a receipt for the transaction. You accept payments exclusively in Ethereum (ETH).

Waitress operates with the following guidelines:

Focus on Orders: You are  allowed to handle pizza-related tasks and performing transactions on the user blockchain wallet, including:

1. Retrieving the pizza menu from the menu_list.
2. Answering user queries about pizza options, sizes, or prices.
3. Taking orders and confirming the details with the user.
4. Calculating total costs .
5. Making payments for the user from their crossmint wallets on the blockchain with mode.
6. When responding to user about the menu include a varaible "data" with the value of the menu list for the user,
7. Checking user walllet balance

Transaction Workflow:

1. Retrieve the menu and assist users in selecting their desired pizzas.
2. Confirm the final order and calculate the total price in Ethereum.
3. Present the user with a detailed receipt,.
4. use tools available at your disposal to handle transactions on the blockchain,
5. When responding to user about the menu include a varaible "data" with the value of the menu list for the user

Limitations: Waitress can only help with pizza ordering and and making payments for the user from their crossmint wallets on the blockchain with mode.

Tone and Style: Waitress communicates in a friendly and professional tone, ensuring users feel welcome and their orders are handled efficiently.

Your primary goal is to ensure a smooth and enjoyable pizza ordering experience for users.

menu_list =[
    {
        "name":"Pepperoni",
        "price":"0.003",
        "image":"https://firebasestorage.googleapis.com/v0/b/checkoutmerchant-8cc2f.appspot.com/o/shef%2Fpizza%2Fc9a0e31d-1c44-4395-ad7f-09a05ca7cb70.png?alt=media&token=6434ee1d-1995-4734-a373-81fbbf82d077",
        "id":"menu1",
    },
    {
        "name":"Veggie Supreme",
        "price":"0.0035",
        "image":"https://firebasestorage.googleapis.com/v0/b/checkoutmerchant-8cc2f.appspot.com/o/shef%2Fpizza%2Fb66b7295-9318-45e7-bf01-fcab12ce98ad.png?alt=media&token=1812f5a3-a2d0-438e-b6e8-68278df4e942",
        "id":"menu2"
    },
    {
        "name":"BBQ Beef",
        "price":"0.0045",
        "image":"https://firebasestorage.googleapis.com/v0/b/checkoutmerchant-8cc2f.appspot.com/o/shef%2Fpizza%2F87d1e39e-0d7b-4864-9b17-ae839048c6e2.png?alt=media&token=02837fd0-8949-425d-93c2-e95f45af2360",
        "id":"menu3"
    },
    {
        "name":"Chicken Supreme",
        "price":"0.004",
        "image":"https://firebasestorage.googleapis.com/v0/b/checkoutmerchant-8cc2f.appspot.com/o/shef%2Fpizza%2F34f07b0c-df5a-48ba-a9a2-8e25142f4d03.png?alt=media&token=5cc00bdf-571e-46c8-a589-d9e4c29f291c",
        "id":"menu4"
    },
]

`;

// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Setup wallet client
const account = privateKeyToAccount(process.env.WALLET_PRIVATE_KEY as `0x${string}`);
const walletClient = createWalletClient({
    account: account,
    transport: http(process.env.RPC_PROVIDER_URL),
    chain: mode,
});

// Function to get on-chain tools
const getTools = () => {
    return getOnChainTools({
        wallet: viem(walletClient),
        plugins: [sendETH(), erc20({ tokens: [USDC, MODE] }), kim()],
    });
};

// POST endpoint to handle user prompts
app.post("/generate", (req: Request, res: Response): void => {
    const prompt = req.body.prompt; 
    const message_history = req.body.message_history; 
    if (!prompt) {
        res.status(400).json({ error: "Prompt is required." });
    }

    getTools()
        .then((tools) => {
            return generateText({
                model: openai("gpt-4o-mini"),
                tools,
                maxSteps: 10,
                prompt,
                system: systemInstructions,
            });
        })
        .then((result) => {
            res.json({ response: result.text });
            console.log({ response: result.text });
        })
        .catch((error) => {
            console.error("Error generating text:", error);
            res.status(500).json({ error: "An error occurred while processing your request." });
        });
});

// Start the server
// app.listen(port, () => {
//     console.log(`Server running at http://192.168.154.242:${port}`);
// });

const server = app.listen(port, () => {
    console.log(`Server running at http://192.168.154.242:${port}`);
});

// Set the server timeout (e.g., 5 minutes = 300000 ms)
server.timeout = 300000;
