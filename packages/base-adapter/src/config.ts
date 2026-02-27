import { base, baseSepolia } from '@reown/appkit/networks';

export const baseConfig = {
    projectId: process.env.NEXT_PUBLIC_REOWN_PROJECT_ID || '',
    networks: [base, baseSepolia],
    defaultNetwork: baseSepolia,
    metadata: {
        name: 'AssetBridge',
        description: 'Cross-chain asset migration protocol with validator consensus on Base and Stacks blockchains.',
        url: 'https://assetbridge.app',
        icons: ['https://assetbridge.app/icon.png']
    }
};

export const CONTRACT_ADDRESSES = {
    [base.id]: process.env.NEXT_PUBLIC_BASE_CONTRACT_ADDRESS || '',
    [baseSepolia.id]: process.env.NEXT_PUBLIC_BASE_SEPOLIA_CONTRACT_ADDRESS || ''
};
