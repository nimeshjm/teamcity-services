using DigitalTechnologies.TeamCity.Services.Infrastructure;

namespace DigitalTechnologies.TeamCity.Services
{
    public class Class1
    {
        private readonly IWebClient webClient;

        private readonly string baseUrl = "https://teamcity.jetbrains.com/";

        public Class1(IWebClient webClient)
        {
            this.webClient = webClient;
        }

        public string GetLastPinnedBuild(string projectName)
        {
            return webClient.DownloadString($"{baseUrl}guestAuth/app/rest/builds/pinned:true,project:{projectName}/number");
        }
    }
}
