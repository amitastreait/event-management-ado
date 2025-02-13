export async function generateRandomCandidate() {
    try {
        const response = await fetch('https://randomuser.me/api/');
        const data = await response.json();
        const user = data.results[0];
        console.log(`User Data ${JSON.stringify(user)}`)
        const jobTitles = ['Software Engineer', 'Product Manager', 'UX Designer', 'Data Scientist', 'Marketing Specialist'];
        const companies = ['TechCorp', 'Innovate Inc.', 'Creative Solutions', 'DataWorks', 'MarketGuru'];
        const tshirtSizes = ['Small', 'Medium', 'Large', 'X-Large'];

        const randomIndex = (arr) => Math.floor(Math.random() * arr.length);

        return {
            name: `${user.name.first} ${user.name.last}`,
            email: user.email,
            phone: user.phone,
            jobTitle: jobTitles[randomIndex(jobTitles)],
            companyName: companies[randomIndex(companies)],
            TShirtSize: tshirtSizes[randomIndex(tshirtSizes)],
            userData: user
        };
    } catch (error) {
        console.error('Error fetching random user:', error);
        return null;
    }
}