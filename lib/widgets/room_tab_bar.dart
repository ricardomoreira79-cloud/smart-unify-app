import 'package:flutter/material.dart';

/// Barra de abas rolável para filtrar por cômodos
/// Suporta múltiplos cômodos com seleção ativa
class RoomTabBar extends StatelessWidget {
  final List<String> rooms;
  final String selectedRoom;
  final ValueChanged<String> onRoomSelected;

  const RoomTabBar({
    super.key,
    required this.rooms,
    required this.selectedRoom,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          rooms.length,
          (index) {
            final room = rooms[index];
            final isSelected = room == selectedRoom;

            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == rooms.length - 1 ? 16 : 8,
              ),
              child: GestureDetector(
                onTap: () => onRoomSelected(room),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                      ? Colors.blue[600]
                      : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: !isSelected
                      ? Border.all(
                          color: Colors.grey[300]!,
                          width: 0.5,
                        )
                      : null,
                  ),
                  child: Text(
                    room,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
