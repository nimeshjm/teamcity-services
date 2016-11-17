namespace DigitalTechnologies.TeamCity.Services.Infrastructure
{
    public interface IWebClient
    {
        string DownloadString(string uri);
    }

    public class SystemWebClient : IWebClient
    {
        private readonly System.Net.WebClient webClient = new System.Net.WebClient();

        public string DownloadString(string uri) => webClient.DownloadString(uri);
    }
}
