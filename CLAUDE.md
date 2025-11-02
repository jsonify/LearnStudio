# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**LearnStudio** is an educational Roblox Studio plugin that teaches game development through interactive guidance, code analysis, and contextual learning. The plugin focuses on teaching concepts rather than automating tasks, helping beginners understand *why* and *how* things work.

**Current Status**: Design phase - only the design document exists. No implementation code yet.

## Technology Stack

- **Language**: Lua (Roblox Studio Plugin API)
- **Build System**: Rojo (for external editor workflow to sync between filesystem and Roblox Studio)
- **UI Framework**: Native Roblox GUI (ScreenGui, Frames, TextLabels, etc.)
- **Version Control**: Git

## Architecture Overview

### Planned Plugin Structure

```
LearnStudio/
├── src/
│   ├── Main.lua                    # Plugin entry point
│   ├── UI/                         # All UI components
│   │   ├── MainWidget.lua          # Primary tabbed interface
│   │   ├── TutorialPanel.lua       # Tutorial step-by-step display
│   │   ├── CodeExplainer.lua       # Script analysis panel
│   │   ├── ChallengePanel.lua      # Practice challenges
│   │   ├── HelpTooltip.lua         # Contextual help popups
│   │   └── Dashboard.lua           # Progress tracking UI
│   ├── Core/                       # Business logic
│   │   ├── TutorialEngine.lua      # State machine for tutorial flow
│   │   ├── CodeAnalyzer.lua        # Lua code parsing and explanation
│   │   ├── ContextDetector.lua     # Monitors user activity in Studio
│   │   ├── ChallengeValidator.lua  # Validates challenge completion
│   │   └── ProgressTracker.lua     # Persists user progress locally
│   ├── Data/                       # Content definitions
│   │   ├── Tutorials/              # Tutorial step definitions
│   │   ├── Challenges/             # Challenge specifications
│   │   ├── Explanations/           # Code pattern explanations
│   │   └── Resources/              # Learning resource metadata
│   └── Utils/                      # Helper modules
│       ├── Highlighter.lua         # Highlights Studio UI elements
│       ├── CodeParser.lua          # Lexer/parser for Lua code
│       └── DataStore.lua           # Plugin settings storage wrapper
```

## Key Design Principles

### Educational Philosophy
- **Scaffolding**: Provide support that gradually removes as competence grows
- **Immediate Feedback**: Validate actions quickly for correct learning reinforcement
- **No Hand-Holding**: Teach users to debug and problem-solve, don't fix things for them
- **Progressive Complexity**: Start simple, gradually introduce advanced concepts

### Technical Principles
- **Performance First**: <5% CPU when idle, <50MB memory, lazy loading of content
- **Context-Aware**: Monitor user activity (selected objects, errors, time on task) to provide relevant help
- **Local-First**: Store all user progress in plugin DataStore (no servers, works offline)
- **Async Operations**: Never block Studio during code analysis or validation

## Core Features to Implement

1. **Interactive Tutorial System**: Step-by-step guided tutorials with UI highlighting and checkpoints
2. **Code Explanation Engine**: Analyzes scripts and provides human-readable explanations
3. **Contextual Help**: Non-intrusive tips based on current Studio activity
4. **Practice Challenges**: Coding/building challenges with automated validation
5. **Debugging Assistant**: Guides users through debugging (doesn't fix for them)
6. **Progress Dashboard**: Visualizes learning journey and achievements

## Critical Roblox Plugin APIs

When implementing, these APIs are essential:

- `plugin:CreateDockWidgetPluginGui()` - Create the main dockable widget
- `plugin:GetMouse()` - Detect user interactions
- `Selection.SelectionChanged` - Monitor what user selects for context detection
- `ScriptEditorService` - Access to script editor (for code analysis)
- `StudioService` - Studio integration features
- `plugin:SetSetting()` / `plugin:GetSetting()` - Persist user progress

## Rojo Workflow

Since this will use Rojo for development:

1. **Project Structure**: Rojo maps filesystem to Roblox place structure via `default.project.json`
2. **Sync Command**: `rojo serve` starts sync server, Roblox Studio plugin connects
3. **Build Command**: `rojo build -o LearnStudio.rbxmx` creates plugin file for distribution
4. **Testing**: Must test in actual Roblox Studio (Lua runtime environment)

## Content Data Format

Tutorials, challenges, and explanations should be stored as structured data (likely Lua tables or JSON):

- **Tutorials**: Sequence of steps with validation criteria and UI highlight targets
- **Challenges**: Requirements, validation logic, hints, solution walkthrough
- **Code Explanations**: Pattern matchers (AST-based) mapped to educational explanations

## Implementation Phases

**Phase 1 MVP** (recommended starting point):
- Basic plugin UI with single tab
- 5 beginner tutorials (hardcoded)
- Simple code explanation for common patterns only
- Basic error interpretation
- Local progress tracking

Focus on proving the concept before building comprehensive content library.

## Performance Optimization Guidelines

- **Debounce Context Detection**: Don't monitor every selection change, use ~500ms debounce
- **Cache Code Explanations**: Store explanations for repeated code patterns
- **Lazy Load Tutorials**: Don't load all tutorial data at plugin start
- **Clean Up UI**: Destroy unused GUI elements when switching tabs
- **Async Analysis**: Use coroutines for code analysis to avoid blocking

## Important Technical Constraints

- **No External Dependencies**: Roblox plugins can't use npm or external Lua libraries
- **Sandboxed Environment**: Limited filesystem access, no arbitrary HTTP requests
- **Studio Version Support**: Must work with latest Studio + 2 versions back
- **No Script Execution in Analysis**: Code analyzer must parse AST, not execute user code (security)

## Testing Approach

Since automated testing for Roblox plugins is limited:

- **Manual Testing**: Every tutorial must be walked through completely in Studio
- **Target Audience Testing**: Observe actual beginners using the plugin
- **Performance Testing**: Monitor memory usage in long Studio sessions with large places
- **Edge Cases**: Test with malformed scripts, empty places, and extreme Studio layouts
