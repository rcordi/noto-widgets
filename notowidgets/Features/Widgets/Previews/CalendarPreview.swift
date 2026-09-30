//
//  CalendarPreview.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct CalendarPreview: View {
    let size: WidgetPreviewSize

    var body: some View {
        WidgetPreviewShell(size: size) {
            switch size {
            case .small:
                todayView

            case .medium:
                weekView

            case .large:
                monthView
            }
        }
    }

    private var todayView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Wednesday")
                        .font(.system(size: 11))
                        .foregroundStyle(AppTheme.accent)

                    Text("30")
                        .font(.system(size: 25, weight: .bold))
                }

                Spacer()

                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            calendarEvent("10:30 AM", "Team Meeting")
            calendarEvent("11:30 AM", "Review Plans")
            calendarEvent("12:30 PM", "Organize Notes")

            HStack {

                Button {
                    // Add event later
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 28, height: 28)
                        .background(AppTheme.secondarySurface)
                        .clipShape(Circle())
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .foregroundStyle(.white)
    }

    private var weekView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("September 2026")
                    .font(.system(size: 14, weight: .bold))

                Spacer()

                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(.secondary)
            }

            HStack {
                ForEach(
                    ["M", "T", "W", "T ", "F", "S", "S "],
                    id: \.self
                ) { day in
                    Text(day)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            HStack {
                ForEach(
                    ["28", "29", "30", "1", "2", "3", "4"],
                    id: \.self
                ) { date in
                    VStack(spacing: 4) {
                        Text(date)
                            .font(.system(size: 12))

                        if date == "30" {
                            Circle()
                                .fill(AppTheme.accent)
                                .frame(width: 5, height: 5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            Spacer()

            HStack {
                Spacer()
                addButton
            }
        }
        .foregroundStyle(.white)
    }

    private var monthView: some View {
        HStack(alignment: .top, spacing: 8) {

            // LEFT: month calendar
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Text("September 2026")
                        .font(.system(size: 15, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Button {
                        // Previous month later
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11, weight: .bold))
                            .frame(width: 26, height: 26)
                            .background(AppTheme.secondarySurface)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PressableButtonStyle())

                    Button {
                        // Next month later
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                            .frame(width: 26, height: 26)
                            .background(AppTheme.secondarySurface)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PressableButtonStyle())

                    Spacer()
                }

                weekdayHeader

                monthGrid

                Spacer()
            }
            .frame(maxWidth: .infinity)

            Divider()

            // RIGHT: today's events
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text("Today")
                        .font(.system(size: 13, weight: .semibold))

                    Spacer()

                    Button {
                        // Refresh later
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 11, weight: .semibold))
                            .frame(width: 28, height: 28)
                            .background(AppTheme.secondarySurface)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PressableButtonStyle())
                }

                Text("Wed, 09-30")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)

                calendarEvent("10:30", "Team Meeting")
                calendarEvent("11:30", "Review Plans")
                calendarEvent("12:30", "Organize Notes")

                Spacer()

                HStack {
                    Spacer()

                    Button {
                        // Add later
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .frame(width: 34, height: 34)
                            .background(AppTheme.secondarySurface)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .frame(width: 95)
        }
        .foregroundStyle(.white)
    }

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(
                Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()),
                id: \.offset
            ) { _, day in
                Text(day)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var monthGrid: some View {
        let days = [
            "31", "1", "2", "3", "4", "5", "6",
            "7", "8", "9", "10", "11", "12", "13",
            "14", "15", "16", "17", "18", "19", "20",
            "21", "22", "23", "24", "25", "26", "27",
            "28", "29", "30", "1", "2", "3", "4"
        ]

        return LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 2),
                count: 7
            ),
            spacing: 8
        ) {
            ForEach(days.indices, id: \.self) { index in
                ZStack {
                    if index == 30 {
                        Circle()
                            .fill(AppTheme.accent)
                            .frame(width: 24, height: 24)
                    }

                    Text(days[index])
                        .font(
                            .system(
                                size: 10,
                                weight: index == 30 ? .semibold : .regular
                            )
                        )
                        .foregroundStyle(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 24)
            }
        }
    }

    private func calendarEvent(
        _ time: String,
        _ title: String
    ) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.accent)
                .frame(width: 3, height: 22)

            VStack(alignment: .leading, spacing: 0) {
                Text(time)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)

                Text(title)
                    .font(.system(size: 10))
                    .lineLimit(1)
            }
        }
        .frame(height: 24)
    }

    private var addButton: some View {
        Image(systemName: "plus")
            .font(.title3)
            .frame(width: 32, height: 32)
            .background(AppTheme.secondarySurface)
            .clipShape(Circle())
    }
}
