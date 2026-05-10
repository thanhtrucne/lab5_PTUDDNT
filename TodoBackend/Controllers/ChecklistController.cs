using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using TodoBackend.Data;
using TodoBackend.Models;

namespace TodoBackend.Controllers;

[Authorize]
[Route("api/todo/{todoId}/checklist")]
[ApiController]
public class ChecklistController : ControllerBase
{
    private readonly AppDbContext _context;

    public ChecklistController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/todo/{todoId}/checklist
    [HttpGet]
    public async Task<IActionResult> GetChecklist(int todoId)
    {
        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var todo = await _context.Todos.FirstOrDefaultAsync(t => t.Id == todoId && t.UserId == userId);
        if (todo == null) return NotFound();

        var items = await _context.ChecklistItems
            .Where(c => c.TodoItemId == todoId)
            .Select(c => new { id = c.Id, text = c.Text, isChecked = c.IsChecked, todoItemId = c.TodoItemId })
            .ToListAsync();

        return Ok(items);
    }

    // POST: api/todo/{todoId}/checklist
    [HttpPost]
    public async Task<IActionResult> AddChecklistItem(int todoId, [FromBody] ChecklistItemDto dto)
    {
        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var todo = await _context.Todos.FirstOrDefaultAsync(t => t.Id == todoId && t.UserId == userId);
        if (todo == null) return NotFound();

        var item = new ChecklistItem
        {
            Text = dto.Text,
            IsChecked = false,
            TodoItemId = todoId
        };

        _context.ChecklistItems.Add(item);
        await _context.SaveChangesAsync();

        return StatusCode(201, new { id = item.Id, text = item.Text, isChecked = item.IsChecked, todoItemId = item.TodoItemId });
    }

    // PUT: api/todo/{todoId}/checklist/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateChecklistItem(int todoId, int id, [FromBody] ChecklistItemDto dto)
    {
        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var todo = await _context.Todos.FirstOrDefaultAsync(t => t.Id == todoId && t.UserId == userId);
        if (todo == null) return NotFound();

        var item = await _context.ChecklistItems.FirstOrDefaultAsync(c => c.Id == id && c.TodoItemId == todoId);
        if (item == null) return NotFound();

        item.Text = dto.Text;
        item.IsChecked = dto.IsChecked;
        await _context.SaveChangesAsync();

        return NoContent();
    }

    // DELETE: api/todo/{todoId}/checklist/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteChecklistItem(int todoId, int id)
    {
        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var todo = await _context.Todos.FirstOrDefaultAsync(t => t.Id == todoId && t.UserId == userId);
        if (todo == null) return NotFound();

        var item = await _context.ChecklistItems.FirstOrDefaultAsync(c => c.Id == id && c.TodoItemId == todoId);
        if (item == null) return NotFound();

        _context.ChecklistItems.Remove(item);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}

public class ChecklistItemDto
{
    public string Text { get; set; } = string.Empty;
    public bool IsChecked { get; set; }
}
