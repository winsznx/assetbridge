/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    transpilePackages: ['@assetbridge/shared', '@assetbridge/base-adapter', '@assetbridge/stacks-adapter'],
};

export default nextConfig;
