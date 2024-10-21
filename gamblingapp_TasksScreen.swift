//
//  gamblingapp_TasksScreen.swift
//  personalproject
//
//  Created by Ryan Lien on 10/20/24.
//
import SwiftUI

struct TasksView: View {
    @State private var openLayers: Set<Int> = []
    @State private var showCompletedTasks = false
    @State private var completedTasks: [CompletedTask] = [
        CompletedTask(task: Task(layer: 1, name: "Basic Profile Completion", points: 10, difficulty: .easy),
                      dateStarted: Date().addingTimeInterval(-86400),
                      dateCompleted: Date(),
                      timeTaken: 15),
        CompletedTask(task: Task(layer: 2, name: "Location Data for Limited Time", points: 50, difficulty: .medium),
                      dateStarted: Date().addingTimeInterval(-172800),
                      dateCompleted: Date().addingTimeInterval(-86400),
                      timeTaken: 45)
    ]
    
    let tasks: [Task] = [
        Task(layer: 1, name: "Device Data Opt-In", points: 15, difficulty: .easy),
        Task(layer: 2, name: "Mobile Browsing Data Sharing", points: 60, difficulty: .medium),
        Task(layer: 3, name: "Financial Data Sharing (Limited Time)", points: 225, difficulty: .hard),
        Task(layer: 3, name: "Personalized App Usage Forecast", points: 250, difficulty: .hard),
        Task(layer: 4, name: "Full Financial Data Integration", points: 500, difficulty: .veryHard),
        Task(layer: 4, name: "Health Data Sharing (Wearable Integration)", points: 550, difficulty: .veryHard)
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Available Tasks")
                        .font(.system(.title, design: .monospaced))
                        .fontWeight(.bold)
                    
                    ForEach(1...4, id: \.self) { layer in
                        LayerView(layer: layer, tasks: tasks, openLayers: $openLayers, completedTasks: $completedTasks)
                    }
                    
                    Toggle("Show Completed Tasks", isOn: $showCompletedTasks)
                        .padding()
                    
                    if showCompletedTasks {
                        CompletedTasksView(completedTasks: completedTasks)
                    }
                }
                .padding()
            }
        }
        .foregroundColor(.white)
        .font(.system(.body, design: .monospaced))
    }
}

struct LayerView: View {
    let layer: Int
    let tasks: [Task]
    @Binding var openLayers: Set<Int>
    @Binding var completedTasks: [CompletedTask]
    
    var body: some View {
        VStack {
            Button(action: {
                toggleLayer()
            }) {
                HStack {
                    Text("Layer \(layer)")
                    Spacer()
                    Image(systemName: openLayers.contains(layer) ? "chevron.up" : "chevron.down")
                }
            }
            
            if openLayers.contains(layer) {
                ForEach(tasks.filter { $0.layer == layer }) { task in
                    TaskRow(task: task, completedTasks: $completedTasks)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private func toggleLayer() {
        if openLayers.contains(layer) {
            openLayers.remove(layer)
        } else {
            openLayers.insert(layer)
        }
    }
}

struct TaskRow: View {
    let task: Task
    @Binding var completedTasks: [CompletedTask]
    @State private var progress: Double = 0.0
    @State private var isInProgress: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(task.name): \(task.points) pts")
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .animation(.linear, value: progress)
            
            Button(isInProgress ? "In Progress" : "Complete") {
                if isInProgress {
                    completeTask()
                } else {
                    startTask()
                }
            }
            .padding(.horizontal)
            .background(isInProgress ? Color.orange : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(5)
    }
    
    private func startTask() {
        isInProgress = true
        withAnimation(.linear(duration: 5)) {
            progress = Double.random(in: 0.1...0.9)
        }
    }
    
    private func completeTask() {
        let completedTask = CompletedTask(
            task: task,
            dateStarted: Date().addingTimeInterval(-Double.random(in: 300...3600)),
            dateCompleted: Date(),
            timeTaken: Int.random(in: 5...60)
        )
        completedTasks.append(completedTask)
        isInProgress = false
        progress = 1.0
    }
}

struct CompletedTasksView: View {
    let completedTasks: [CompletedTask]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Completed Tasks")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
            
            ForEach(completedTasks) { completedTask in
                VStack(alignment: .leading) {
                    Text(completedTask.task.name)
                        .font(.headline)
                    Text("Points: \(completedTask.task.points)")
                    Text("Started: \(formattedDate(completedTask.dateStarted))")
                    Text("Completed: \(formattedDate(completedTask.dateCompleted))")
                    Text("Time taken: \(completedTask.timeTaken) minutes")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct Task: Identifiable {
    let id = UUID()
    let layer: Int
    let name: String
    let points: Int
    let difficulty: Difficulty
}

struct CompletedTask: Identifiable {
    let id = UUID()
    let task: Task
    let dateStarted: Date
    let dateCompleted: Date
    let timeTaken: Int
}

enum Difficulty: Int {
    case easy = 1
    case medium
    case hard
    case veryHard
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
