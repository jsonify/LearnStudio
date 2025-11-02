# LearnStudio Development Plan

> **Current Status**: Phase 1.2 - Tutorial Engine Complete! Ready for Studio Testing
> **Last Updated**: 2025-11-02
> **Version**: 0.1.0-alpha

---

## Project Overview

**LearnStudio** is an educational Roblox Studio plugin that teaches game development through interactive guidance, code analysis, and contextual learning. We're building this in phases to deliver value incrementally.

---

## Current State Assessment

### ✅ Completed
- [x] Project structure created
- [x] Rojo configuration (sync + plugin build) - **Fixed module path issues**
- [x] Basic plugin shell with toolbar button
- [x] Main widget window with tab system
- [x] Development workflow documented
- [x] Comprehensive design document
- [x] **Phase 1.1: UI Framework Complete**
  - [x] Theme system with full design tokens
  - [x] TabSystem component (left vertical sidebar, VS Code style)
  - [x] TabPanel component (reusable content container)
  - [x] 3 tab content placeholders (Tutorials, Code Help, Dashboard)
  - [x] Tab switching with visual feedback (hover, active states)
  - [x] Plugin build configuration debugged and working

### ✅ Just Completed
- [x] **Phase 1.2: Tutorial Engine** - Complete and ready for testing!

### 📋 Not Started
- [ ] Phase 1.3: Code Explanation Engine
- [ ] Phase 1.4: Progress Tracking
- [ ] Phase 1.5: Polish & Testing
- [ ] Tutorial content creation
- [ ] Testing with real users

---

## Phase 1: MVP - Foundation & Core Experience
**Target**: 2-3 weeks | **Goal**: Prove the concept with minimal viable features

### ✅ 1.1 UI Framework (Week 1) - **COMPLETE**
**Goal**: Create reusable UI components and tab system

- [x] **Tab System Implementation** `src/UI/Components/TabSystem.lua`
  - [x] Create TabSystem component (left sidebar navigation)
  - [x] Create TabPanel component (content areas)
  - [x] Implement tab switching logic
  - [x] Add visual states (active, inactive, hover)
  - [x] Clean destroy/cleanup methods

- [x] **Theme System** `src/UI/Theme.lua`
  - [x] Define color palette (dark mode focused)
  - [x] Typography scale (fonts, sizes, weights)
  - [x] Spacing/padding constants
  - [x] Animation durations
  - [x] Component style presets
  - [x] Helper functions (padding, corners, dividers)

- [x] **Tab Content Placeholders**
  - [x] TutorialPanel.lua
  - [x] CodeExplainer.lua
  - [x] Dashboard.lua

- [x] **Bug Fixes**
  - [x] Fixed plugin.project.json module structure
  - [x] Fixed require() paths in Main.server.lua
  - [x] Tested and verified tab system works

- [ ] **UI Components Library** `src/UI/Components/` (Deferred - build as needed)
  - [ ] Button component (primary, secondary, ghost styles)
  - [ ] Card component (for tutorial/challenge items)
  - [ ] ScrollingFrame wrapper with consistent styling
  - [ ] InfoBox component (tips, warnings, success messages)

**Success Criteria**: ✅ Clean tab navigation with 3 placeholder tabs - **ACHIEVED**

---

### ✅ 1.2 Tutorial Engine (Week 1-2) - **COMPLETE**
**Goal**: Implement tutorial system with 3 working tutorials

- [x] **Tutorial Core** `src/Core/TutorialEngine.lua`
  - [x] Tutorial state machine (idle, active, waiting, completed)
  - [x] Step validation system
  - [x] Progress persistence (save/load state)
  - [x] Event system for tutorial triggers

- [x] **Tutorial UI** `src/UI/TutorialPanel.lua`
  - [x] Tutorial list view with difficulty badges
  - [x] Active tutorial step display
  - [x] Progress indicator (X/Y steps)
  - [x] Next/Previous navigation
  - [x] Exit/Reset functionality
  - [x] Hint system with toggle
  - [x] Automatic vs manual validation UI states

- [x] **Studio Integration** `src/Core/StudioMonitor.lua`
  - [x] Selection change detection
  - [x] Part creation detection
  - [x] Script creation detection
  - [x] Property modification tracking
  - [x] Object creation detection (ClickDetector, etc.)
  - [x] Debounced event handling

- [x] **Tutorial Content** `src/Data/Tutorials/`
  - [x] Tutorial 1: "Insert Your First Part" (5 steps)
  - [x] Tutorial 2: "Create a Moving Platform" (8 steps)
  - [x] Tutorial 3: "Make a Clickable Button" (10 steps)
  - [x] Tutorial data format/schema definition
  - [x] Rojo configuration updated

**Success Criteria**: ✅ Implementation complete - Ready for Studio testing!

---

### 1.3 Code Explanation Engine (Week 2)
**Goal**: Basic code analysis for common patterns

- [ ] **Code Parser** `src/Utils/CodeParser.lua`
  - [ ] Lua lexer (tokenize Lua code)
  - [ ] AST builder (parse tokens into tree structure)
  - [ ] Pattern matchers (identify common code structures)
  - [ ] Safe error handling (don't crash on malformed code)

- [ ] **Explanation System** `src/Core/CodeAnalyzer.lua`
  - [ ] Pattern-to-explanation mapping
  - [ ] Line-by-line breakdown generator
  - [ ] API documentation lookup (for Roblox APIs)
  - [ ] Explanation caching (performance)

- [ ] **Explanation UI** `src/UI/CodeExplainer.lua`
  - [ ] "Explain Selected Script" button integration
  - [ ] Scrollable explanation panel
  - [ ] Syntax highlighting for code samples
  - [ ] Collapsible sections for long explanations

- [ ] **Explanation Database** `src/Data/Explanations/`
  - [ ] Common Roblox APIs (Players, Workspace, ReplicatedStorage)
  - [ ] Control flow (if/then, loops, functions)
  - [ ] Events (.Changed, .Touched, .PlayerAdded)
  - [ ] Best practices notes

**Success Criteria**: Can explain 20+ common Roblox code patterns with clear, beginner-friendly language

---

### 1.4 Progress Tracking (Week 3)
**Goal**: Persistent user progress and basic dashboard

- [ ] **Progress System** `src/Core/ProgressTracker.lua`
  - [ ] DataStore wrapper for plugin settings
  - [ ] Tutorial completion tracking
  - [ ] Time-on-task metrics
  - [ ] Achievement/badge system (basic)

- [ ] **Dashboard UI** `src/UI/Dashboard.lua`
  - [ ] Summary stats (tutorials completed, time spent)
  - [ ] Recent activity list
  - [ ] Next recommended tutorial
  - [ ] Simple progress visualization (bars/percentages)

**Success Criteria**: Progress persists across Studio sessions, dashboard shows accurate stats

---

### 1.5 Polish & Testing (Week 3)
**Goal**: Bug-free, smooth user experience

- [ ] **Performance Optimization**
  - [ ] Profile CPU usage (target <5% idle)
  - [ ] Profile memory usage (target <50MB)
  - [ ] Lazy load tutorial content
  - [ ] Debounce Studio event listeners

- [ ] **Error Handling**
  - [ ] Graceful degradation for missing data
  - [ ] User-friendly error messages
  - [ ] Logging system for debugging

- [ ] **User Testing**
  - [ ] Test with 3-5 actual beginners
  - [ ] Gather feedback on clarity and usefulness
  - [ ] Identify pain points and confusion
  - [ ] Iterate on tutorial wording

- [ ] **Documentation**
  - [ ] User guide (in-plugin help tab)
  - [ ] Developer README update
  - [ ] Code documentation (comments)

**Success Criteria**: Plugin is stable, performant, and usable by complete beginners

---

## Phase 2: Enhanced Learning Features
**Target**: 3-4 weeks after Phase 1 | **Goal**: Add depth and interactivity

### Features to Add
- [ ] **Contextual Help System**
  - Auto-detect user actions and show relevant tips
  - "Did you know?" tooltips based on context
  - Error pattern recognition and suggestions

- [ ] **Practice Challenges**
  - 10 coding challenges with validation
  - Hints system (progressive disclosure)
  - Solution walkthroughs (show, don't do)

- [ ] **Advanced Code Analysis**
  - Performance issue detection
  - Security vulnerability warnings
  - Refactoring suggestions

- [ ] **Learning Resources**
  - Curated external links
  - Roblox Creator Hub integration
  - Video tutorial embedding

---

## Phase 3: Intelligence & Scaling
**Target**: 4-6 weeks after Phase 2 | **Goal**: Smart assistance and content expansion

### Features to Add
- [ ] **Smart Debugging Assistant**
  - Common error pattern recognition
  - Guided debugging workflow
  - "What did you try?" prompts

- [ ] **Adaptive Learning Path**
  - Personalized tutorial recommendations
  - Difficulty adjustment based on performance
  - Skill gap identification

- [ ] **Content Expansion**
  - 20+ total tutorials
  - 30+ practice challenges
  - Comprehensive API explanations

- [ ] **Community Features**
  - Share custom tutorials (JSON export/import)
  - Achievement showcase
  - Learning streak tracking

---

## Phase 4: Professional Features
**Target**: TBD | **Goal**: Advanced users and classroom use

### Features to Add
- [ ] Classroom mode (teacher dashboard)
- [ ] Multi-language support
- [ ] Advanced project templates
- [ ] Plugin marketplace preparation
- [ ] Analytics and insights

---

## Technical Debt & Maintenance

### Current Technical Debt
- Custom icon for toolbar button (using placeholder)
- Need comprehensive test suite
- Performance profiling not yet done

### Ongoing Maintenance Tasks
- Keep Roblox API explanations up-to-date
- Monitor Studio API changes
- Respond to user feedback
- Fix bugs as discovered

---

## Success Metrics & KPIs

### Phase 1 Success Criteria
- ✅ Plugin installs without errors
- ✅ All 3 tutorials completable
- ✅ Code explainer works on 20+ patterns
- ✅ <5% CPU usage when idle
- ✅ <50MB memory footprint
- ✅ Positive feedback from 3+ test users

### Long-term Goals
- 100+ active users
- 80%+ tutorial completion rate
- <5% error rate
- 4+ star average rating

---

## Risk Management

### Known Risks
1. **Roblox API Changes**: Studio API may change, breaking functionality
   - Mitigation: Follow Roblox release notes, version testing

2. **Performance Issues**: Large codebases may slow analysis
   - Mitigation: Async processing, result caching, scope limiting

3. **User Confusion**: Educational content may be unclear
   - Mitigation: User testing, iterative wording improvements

4. **Scope Creep**: Feature requests may derail timeline
   - Mitigation: Strict phase adherence, "Phase N" backlog

---

## 🎯 Next Immediate Steps

### ✅ Just Completed (Week 1-2)
1. ✅ Created PLAN.md
2. ✅ Implemented tab system UI (left vertical sidebar)
3. ✅ Created Theme system with full design tokens
4. ✅ Fixed plugin build configuration and module paths
5. ✅ Tested and verified plugin works in Studio
6. ✅ **Implemented complete Tutorial Engine system**
   - Tutorial data format and 3 tutorial files
   - TutorialEngine.lua core logic
   - StudioMonitor.lua for event detection
   - TutorialPanel.lua with real UI
   - Integrated everything in Main.server.lua
   - Updated Rojo configuration

### 🔄 Next Up: Studio Testing & Phase 1.3 - Code Explanation Engine

**✅ COMPLETED - All Priority Items Done!**

1. ✅ **Tutorial Data Format** `src/Data/Tutorials/`
   - Defined comprehensive tutorial step schema
   - Created 3 tutorial data files with full content
   - Schema includes validation, hints, details, metadata

2. ✅ **Tutorial Core Logic** `src/Core/TutorialEngine.lua`
   - Complete state machine implementation
   - Tutorial loading and management
   - Step validation with multiple validation types
   - Event callback system
   - Progress persistence

3. ✅ **Studio Monitor** `src/Core/StudioMonitor.lua`
   - Selection change detection with debouncing
   - Part/script/object creation detection
   - Property change tracking
   - Comprehensive validation support

4. ✅ **Tutorial Panel UI** `src/UI/TutorialPanel.lua`
   - Tutorial list view with cards
   - Active tutorial view with step display
   - Progress indicators
   - Navigation controls
   - Hint system

5. ⏭️ **Test Complete Flow** - Ready for Roblox Studio testing
   - All code complete and integrated
   - Needs manual testing in actual Studio environment
   - Progress persistence implemented

**First Milestone**: ✅ Complete! All 3 tutorials implemented and ready to test

### Weekly Cadence
- **Monday**: Review plan, set weekly goals
- **Wednesday**: Mid-week progress check
- **Friday**: Demo working features, adjust plan
- **Sunday**: Reflect and prepare for next week

---

## Notes & Decisions

### Design Decisions
- **Dark theme only**: Most developers prefer dark mode, simplifies theming
- **Local-first**: No servers = works offline, privacy-friendly, simpler architecture
- **Progressive disclosure**: Show simple first, reveal complexity gradually
- **No automation**: Plugin teaches, doesn't do work for users

### Implementation Choices
- **No external libraries**: Roblox plugins are sandboxed, pure Lua only
- **Lazy loading**: Don't load all tutorials on startup for performance
- **Async parsing**: Use coroutines for code analysis to avoid blocking
- **ModuleScript architecture**: Clean separation of concerns

---

## Resources & References

### Documentation
- [Roblox Plugin API](https://create.roblox.com/docs/reference/engine/classes/Plugin)
- [Rojo Documentation](https://rojo.space/docs/)
- [Lua 5.1 Reference](https://www.lua.org/manual/5.1/)

### Design Inspiration
- GitHub Copilot Labs (explanations)
- VSCode interactive tutorials
- Khan Academy coding environment

---

**End of Plan Document**

*This plan is a living document. Update it as we learn and adapt.*
