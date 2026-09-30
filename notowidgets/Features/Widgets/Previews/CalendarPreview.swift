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
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Wednesday")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.accent)

                    Text("30")
                        .font(.system(size: 42, weight: .bold))
                }

                Spacer()

                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(.secondary)
            }

            calendarEvent("10:30 AM", "Team Meeting")
            calendarEvent("11:30 AM", "Review Plans")
            calendarEvent("12:30 PM", "Organize Notes")

            Spacer()

            HStack {
                Spacer()

                addButton
            }
        }
        .foregroundStyle(.white)
    }

    private var weekView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("September 2026")
                    .font(.headline)
                    .fontWeight(.bold)

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
                        .font(.caption)
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
                            .font(.subheadline)

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
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text("September 2026")
                    .font(.headline)
                    .fontWeight(.bold)

                weekdayHeader

                monthGrid
            }
            .frame(maxWidth: .infinity)

            Divider()

            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Text("Today")
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(.secondary)
                }

                calendarEvent("10:30", "Team Meeting")
                calendarEvent("11:30", "Review Plans")
                calendarEvent("12:30", "Organize Notes")

                Spacer()

                HStack {
                    Spacer()
                    addButton
                }
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(.white)
    }

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(
                ["M", "T", "W", "T ", "F", "S", "S "],
                id: \.self
            ) { day in
                Text(day)
                    .font(.caption2)
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
            "28", "29", "30", "1 ", "2 ", "3 ", "4 "
        ]

        return LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible()),
                count: 7
            ),
            spacing: 10
        ) {
            ForEach(days.indices, id: \.self) { index in
                Text(days[index])
                    .font(.caption2)
                    .foregroundStyle(
                        index == 30
                        ? AppTheme.accent
                        : .white
                    )
            }
        }
    }

    private func calendarEvent(
        _ time: String,
        _ title: String
    ) -> some View {
        HStack(spacing: 7) {
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.accent)
                .frame(width: 4, height: 27)

            VStack(alignment: .leading, spacing: 0) {
                Text(time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(title)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
    }

    private var addButton: some View {
        Image(systemName: "plus")
            .font(.title3)
            .frame(width: 38, height: 38)
            .background(AppTheme.secondarySurface)
            .clipShape(Circle())
    }
}
