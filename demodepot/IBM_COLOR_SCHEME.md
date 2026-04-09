# IBM Design Language Color Scheme - DemoDepot

## Current Implementation

All buttons and UI elements in the DemoDepot application follow the **official IBM Design Language** color palette.

## IBM Colors Used

### Primary Colors
- **Primary Blue** (#0f62fe) - IBM Blue 60
  - Used for: Primary buttons, links, active states
  - Hover: #0043ce (IBM Blue 70)
  - Active: #002d9c (IBM Blue 80)

### Secondary Colors
- **Green** (#24a148) - IBM Green 50
  - Used for: Edit buttons, success states
  - Hover: #198038 (IBM Green 60)

- **Red** (#da1e28) - IBM Red 60
  - Used for: Delete buttons, danger states, errors
  - Hover: #dc2626

- **Orange** (#ff832b) - IBM Orange 40
  - Used for: Accent elements, highlights

- **Yellow** (#f1c21b) - IBM Yellow 30
  - Used for: Warning states, in-progress status

### Neutral Colors (IBM Gray Scale)
- **Gray 10**: #f4f4f4 (Backgrounds)
- **Gray 20**: #e0e0e0 (Borders)
- **Gray 30**: #c6c6c6 (Disabled states)
- **Gray 50**: #8d8d8d (Secondary text)
- **Gray 70**: #525252 (Body text)
- **Gray 100**: #161616 (Headings, dark text)

## Button Color Mapping

### `.btn-primary`
- Background: **#0f62fe** (IBM Blue 60)
- Hover: **#0043ce** (IBM Blue 70)
- Active: **#002d9c** (IBM Blue 80)
- Used for: Submit, Refresh, View, Update Status

### `.btn-secondary`
- Background: **#24a148** (IBM Green 50)
- Hover: **#198038** (IBM Green 60)
- Used for: Edit, New Request

### `.btn-danger`
- Background: **#da1e28** (IBM Red 60)
- Hover: **#dc2626**
- Used for: Delete, Cancel

### `.btn-outline`
- Border: **#c6c6c6** (IBM Gray 30)
- Hover Border: **#0f62fe** (IBM Blue 60)
- Used for: Cancel, Secondary actions

## Status Badge Colors

### Draft
- Background: **#e0e0e0** (IBM Gray 20)
- Text: **#525252** (IBM Gray 70)
- Icon: 📝

### Submitted
- Background: **#dbeafe** (Light Blue)
- Text: **#1e40af** (Dark Blue)
- Icon: 📤

### In Progress
- Background: **#fef3c7** (Light Yellow)
- Text: **#92400e** (Dark Yellow)
- Icon: ⚙️

### Completed
- Background: **#d1fae5** (Light Green)
- Text: **#065f46** (Dark Green)
- Icon: ✅

### Cancelled
- Background: **#fee2e2** (Light Red)
- Text: **#991b1b** (Dark Red)
- Icon: ❌

## Typography

**Font Family**: IBM Plex Sans
- Imported from Google Fonts
- Weights: 400 (Regular), 500 (Medium), 600 (Semi-Bold), 700 (Bold)

## Where Colors Are Applied

### Admin Dashboard
- ✅ Refresh button: IBM Blue
- ✅ Update Status button: IBM Blue
- ✅ Update button in table: IBM Blue
- ✅ File download links: IBM Blue

### User Dashboard
- ✅ Refresh button: IBM Blue
- ✅ View button: IBM Blue
- ✅ Edit button: IBM Green
- ✅ Delete button: IBM Red

### Demo Request Form
- ✅ Submit button: IBM Blue gradient
- ✅ Save as Draft button: White with IBM Blue border

### Public Dashboard
- ✅ Refresh button: IBM Blue
- ✅ All links: IBM Blue
- ✅ Status badges: IBM color scheme

## Compliance

✅ All colors are from the official IBM Design Language palette
✅ Proper contrast ratios for accessibility
✅ Consistent hover and active states
✅ IBM Plex Sans font family throughout

## References

- IBM Design Language: https://www.ibm.com/design/language/
- IBM Color Palette: https://www.ibm.com/design/language/color
- IBM Plex Font: https://www.ibm.com/plex/