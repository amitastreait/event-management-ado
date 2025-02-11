export async function generateRandomAddress() {
    try {
        const response = await fetch('https://random-data-api.com/api/address/random_address');
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching random address:', error);
        return null;
    }
}