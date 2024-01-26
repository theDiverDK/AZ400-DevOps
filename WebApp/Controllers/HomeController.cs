using System.Diagnostics;
using System.Linq;
using System.Text;
using Azure.Identity;
using Azure.Storage.Blobs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WebApp.Models;

namespace WebApp.Controllers;

[Authorize]
public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        GetListFromStorageAccount();
        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [AllowAnonymous]
    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }

    public void GetListFromStorageAccount()
    {
        var url = "https://storage010572.blob.core.windows.net/webcontainer";

        var cred = new DefaultAzureCredential();
        var containerClient = new BlobContainerClient(new Uri(url), cred);

        try
        {
          

            // Upload text to a new block blob.
            byte[] byteArray = Encoding.ASCII.GetBytes("Hello world");

            using var stream = new MemoryStream(byteArray);
            containerClient.UploadBlob("file.txt", stream);
        }
        catch (Exception e)
        {
            throw e;
        }
    }
}