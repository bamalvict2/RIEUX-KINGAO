using KINGDomaine.Shared.DTOs;

namespace KINGDomaine.Api.Services;

public class ItemService
{
    public IEnumerable<ItemDto> GetAll()
    {
        return new List<ItemDto>
        {
            new ItemDto { Id = 1, Name = "Item A" },
            new ItemDto { Id = 2, Name = "Item B" }
        };
    }
}
