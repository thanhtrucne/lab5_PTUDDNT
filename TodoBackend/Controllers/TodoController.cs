using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using TodoBackend.Data;
using TodoBackend.DTOs;
using TodoBackend.Models;

namespace TodoBackend.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class TodoController : ControllerBase
{
    private readonly AppDbContext _context;

    public TodoController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetTodos()
    {
        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var todos = await _context.Todos
            .Where(t => t.UserId == userId)
            .Select(t => new
            {
                id = t.Id,
                title = t.Title,
                description = t.Description,
                isCompleted = t.IsCompleted,
                createdAt = t.CreatedAt,
                userId = t.UserId
            })
            .ToListAsync();
        return Ok(todos);
    }

    [HttpPost]
    public async Task<IActionResult> CreateTodo([FromBody] CreateTodoDto dto)
    {
        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var todoItem = new TodoItem
        {
            Title = dto.Title,
            Description = dto.Description,
            IsCompleted = false,
            UserId = userId,
            CreatedAt = DateTime.UtcNow
        };

        _context.Todos.Add(todoItem);
        await _context.SaveChangesAsync();

        return StatusCode(201, new
        {
            id = todoItem.Id,
            title = todoItem.Title,
            description = todoItem.Description,
            isCompleted = todoItem.IsCompleted,
            createdAt = todoItem.CreatedAt,
            userId = todoItem.UserId
        });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateTodo(int id, TodoItem todoItem)
    {
        if (id != todoItem.Id) return BadRequest();

        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var existingTodo = await _context.Todos.FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

        if (existingTodo == null) return NotFound();

        existingTodo.Title = todoItem.Title;
        existingTodo.Description = todoItem.Description;
        existingTodo.IsCompleted = todoItem.IsCompleted;

        await _context.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteTodo(int id)
    {
        var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
        var todoItem = await _context.Todos.FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

        if (todoItem == null) return NotFound();

        _context.Todos.Remove(todoItem);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
