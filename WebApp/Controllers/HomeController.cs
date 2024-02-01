﻿using System.Diagnostics;
using System.Linq;
using System.Text;
using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Specialized;
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
        var containerClient = GetBlobContainerClient();

        try
        {
            var blobList = containerClient.GetBlobs();

            foreach (var blob in blobList)
            {
                var name = blob.Name;
            }
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    private static BlobContainerClient GetBlobContainerClient()
    {
        var url = "https://storage010572.blob.core.windows.net/webcontainer";

        var cred = new DefaultAzureCredential();
        var containerClient = new BlobContainerClient(new Uri(url), cred);
        
        return containerClient;
    }
}