"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const body_parser_1 = __importDefault(require("body-parser"));
const openai_1 = require("@ai-sdk/openai");
const ai_1 = require("ai");
const viem_1 = require("viem");
const viem_2 = require("viem");
const accounts_1 = require("viem/accounts");
const chains_1 = require("viem/chains");
const adapter_vercel_ai_1 = require("@goat-sdk/adapter-vercel-ai");
const plugin_erc20_1 = require("@goat-sdk/plugin-erc20");
const plugin_kim_1 = require("@goat-sdk/plugin-kim");
const wallet_evm_1 = require("@goat-sdk/wallet-evm");
const wallet_viem_1 = require("@goat-sdk/wallet-viem");
require("dotenv").config();
// Initialize wallet client
const account = (0, accounts_1.privateKeyToAccount)(process.env.WALLET_PRIVATE_KEY);
const walletClient = (0, viem_2.createWalletClient)({
    account: account,
    transport: (0, viem_1.http)(process.env.RPC_PROVIDER_URL),
    chain: chains_1.mode,
});
// Initialize Express app
const app = (0, express_1.default)();
const port = process.env.PORT || 3000;
// Middleware
app.use(body_parser_1.default.json());
(() => __awaiter(void 0, void 0, void 0, function* () {
    // Load on-chain tools
    const tools = yield (0, adapter_vercel_ai_1.getOnChainTools)({
        wallet: (0, wallet_viem_1.viem)(walletClient),
        plugins: [(0, wallet_evm_1.sendETH)(), (0, plugin_erc20_1.erc20)({ tokens: [plugin_erc20_1.USDC, plugin_erc20_1.MODE] }), (0, plugin_kim_1.kim)()],
    });
    // API Endpoint for AI Agent interaction
    app.post("/api/agent", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        const { prompt } = req.body;
        if (!prompt || typeof prompt !== "string") {
            return res.status(400).json({ error: "Invalid prompt provided" });
        }
        try {
            console.log("\n-------------------\n");
            console.log("TOOLS CALLED");
            console.log("\n-------------------\n");
            const result = yield (0, ai_1.generateText)({
                model: (0, openai_1.openai)("gpt-4o-mini"),
                tools: tools,
                maxSteps: 10,
                prompt: prompt,
                onStepFinish: (event) => {
                    console.log(event.toolResults);
                },
            });
            console.log("\n-------------------\n");
            console.log("RESPONSE");
            console.log("\n-------------------\n");
            console.log(result.text);
            // Send response
            res.status(200).json({ response: result.text });
        }
        catch (error) {
            console.error(error);
            res.status(500).json({ error: "An error occurred while processing the prompt" });
        }
    }));
    // Start the server
    app.listen(port, () => {
        console.log(`Server is running on http://localhost:${port}`);
    });
}))();
