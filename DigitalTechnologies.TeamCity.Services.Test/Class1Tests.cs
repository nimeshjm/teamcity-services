using DigitalTechnologies.TeamCity.Services.Infrastructure;
using Moq;
using NUnit.Framework;

namespace DigitalTechnologies.TeamCity.Services.Test
{
    [TestFixture]
    public class Class1Tests
    {
        [Test]
        public void A()
        {
            var webclientMock = new Mock<IWebClient>();
            webclientMock.Setup(m => m.DownloadString(It.IsAny<string>())).Returns("4");

            var sut = new Class1(webclientMock.Object);

            var actual = sut.GetLastPinnedBuild("Kotlin");

            Assert.That(actual, Is.EqualTo("4"));
        }
    }
}
