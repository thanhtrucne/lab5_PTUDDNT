namespace TodoBackend.Models;

public class ChecklistItem
{
    public int Id { get; set; }
    public string Text { get; set; } = string.Empty;
    public bool IsChecked { get; set; }
    public int TodoItemId { get; set; }
    public TodoItem TodoItem { get; set; } = null!;
}
