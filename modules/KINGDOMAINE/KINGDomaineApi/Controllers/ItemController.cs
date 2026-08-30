using Microsoft.AspNetCore.Mvc;
using KINGDomaine.Api.Services;
using KINGDomaine.Shared.DTOs;

namespace KINGDomaine.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ItemController : ControllerBase
{
    private readonly ItemService _service;

    public ItemController(ItemService service)
    {
        _service = service;
    }

    [HttpGet]
    public IActionResult GetAll()
    {
        var items = _service.GetAll();
        return Ok(items);
    }
}
