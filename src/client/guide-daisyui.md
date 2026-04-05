# COLORS

---
title: Colors
desc: How to use daisyUI colors?
---

<script>
  import Translate from "$components/Translate.svelte"
</script>

## <Translate text="Introduction" />

<Translate text="daisyUI is fully themeable and colorable," />
<Translate text="So instead of using constant color utility classes like:" />

- <span class="badge badge-xs bg-green-500"></span> bg-green-500
- <span class="badge badge-xs bg-orange-600"></span> bg-orange-600
- <span class="badge badge-xs bg-blue-700"></span> bg-blue-700
- <Translate text="etc." />

<Translate text="It's suggested to use semantic color utility classes like:" />

- <span class="badge badge-xs bg-primary"></span> bg-primary
- <span class="badge badge-xs bg-secondary"></span> bg-secondary
- <span class="badge badge-xs bg-accent"></span> bg-accent
- <Translate text="etc." />

<Translate text="Each color name contains CSS variables and each daisyUI theme applies color values to the utility classes when it is applied." />

## <Translate text="Benefits" />

<Translate text="Semantic color names make more sense because when we design interfaces, we don't just use any random color. We define a specific color palette with names like <code>primary</code>, <code>secondary</code>, etc. and we only use those specific colors in our interfaces." />
<Translate text="Also, using semantic color names makes theming easier. You wouldn't have to define dark-mode colors for every single element and you wouldn't be limited to only light/dark themes. you can have multiple themes available and each theme is just a few lines of CSS variables." />

Example of theming a div with hardcoded color values

<div class="lg:grid lg:grid-cols-2 gap-4">
<div>

_Using hardcoded color names_

<div class="p-10 bg-zinc-100 rounded-2xl">
  <div class="p-6 bg-zinc-50 border-2 border-zinc-200 text-zinc-800 rounded-lg [text-wrap:balance]">
    This is a hardcoded dark text on a light background,
    it needs double the amount of class names to support dark mode.
  </div>
</div>

```html
<div class="bg-zinc-100">
  <div class="border-zinc-200 bg-zinc-50 text-zinc-800">
    This is a hardcoded dark text on a light background, it needs double the amount of class names
    to support dark mode.
  </div>
</div>
```

- 🪦 Fixed color names, hardcoded based on the value
- 🚫 No automatic dark mode
- 😵‍💫 You have to add dark-mode colors for every element
- 💸 high maintenance cost
- 🐢 slow development
- 😩 hard to change a theme
- ⛓️‍💥 high chance of inconsistency
- 😰 You are limited to 2 themes only: light and dark

</div>
<div>

_Using semantic color names_

<div class="p-10 bg-base-200 rounded-2xl">
  <div class="p-6 bg-base-100 border-2 border-base-300 text-base-content rounded-lg [text-wrap:balance]">
    This is dark text on a light background,
    which switches to light text on a dark background in dark mode.
  </div>
</div>

```html
<div class="bg-base-200">
  <div class="bg-base-100 border-base-300 text-base-content">
    This is dark text on a light background, which switches to light text on a dark background in
    dark mode.
  </div>
</div>
```

- 🎯 Semantic names, based on the purpose of the color
- ✨ Automatic dark mode
- 🌓 No need to add any dark-mode class names
- 🤑 Zero maintenance cost to add a theme
- 🚀 Fast development
- ⚡️ Easy to change themes
- 📘 All colors are consistent based on the design system
- ♾️ Unlimited themes, easy to switch

</div>
</div>

## <Translate text="List of all daisyUI color names" />

<Translate text="You can use these color names in your theme or in utility classes." />

<div class="overflow-x-auto">
<div class="whitespace-nowrap">

|                                                  | Color name        | CSS variable                | Where to use                                                       |
| ------------------------------------------------ | ----------------- | --------------------------- | ------------------------------------------------------------------ |
| <span class="badge bg-primary"></span>           | primary           | `--color-primary`           | Primary brand color, The main color of your brand                  |
| <span class="badge bg-primary-content"></span>   | primary-content   | `--color-primary-content`   | Foreground content color to use on `primary` color <br/><br/>      |
| <span class="badge bg-secondary"></span>         | secondary         | `--color-secondary`         | Secondary brand color, The optional, secondary color of your brand |
| <span class="badge bg-secondary-content"></span> | secondary-content | `--color-secondary-content` | Foreground content color to use on `secondary` color <br/><br/>    |
| <span class="badge bg-accent"></span>            | accent            | `--color-accent`            | Accent brand color, The optional, accent color of your brand       |
| <span class="badge bg-accent-content"></span>    | accent-content    | `--color-accent-content`    | Foreground content color to use on `accent` color <br/><br/>       |
| <span class="badge bg-neutral"></span>           | neutral           | `--color-neutral`           | Neutral dark color, For not-saturated parts of UI                  |
| <span class="badge bg-neutral-content"></span>   | neutral-content   | `--color-neutral-content`   | Foreground content color to use on `neutral` color <br/><br/>      |
| <span class="badge bg-base-100"></span>          | base-100          | `--color-base-100`          | Base surface color of page, used for blank backgrounds             |
| <span class="badge bg-base-200"></span>          | base-200          | `--color-base-200`          | Base color, darker shade, to create elevations                     |
| <span class="badge bg-base-300"></span>          | base-300          | `--color-base-300`          | Base color, even more darker shade, to create elevations           |
| <span class="badge bg-base-content"></span>      | base-content      | `--color-base-content`      | Foreground content color to use on `base` color <br/><br/>         |
| <span class="badge bg-info"></span>              | info              | `--color-info`              | Info color, For informative/helpful messages                       |
| <span class="badge bg-info-content"></span>      | info-content      | `--color-info-content`      | Foreground content color to use on `info` color                    |
| <span class="badge bg-success"></span>           | success           | `--color-success`           | Success color, For success/safe messages                           |
| <span class="badge bg-success-content"></span>   | success-content   | `--color-success-content`   | Foreground content color to use on `success` color                 |
| <span class="badge bg-warning"></span>           | warning           | `--color-warning`           | Warning color, For warning/caution messages                        |
| <span class="badge bg-warning-content"></span>   | warning-content   | `--color-warning-content`   | Foreground content color to use on `warning` color                 |
| <span class="badge bg-error"></span>             | error             | `--color-error`             | Error color, For error/danger/destructive messages                 |
| <span class="badge bg-error-content"></span>     | error-content     | `--color-error-content`     | Foreground content color to use on `error` color                   |

</div>
</div>

## <Translate text="How to use" />

<Translate text="Some daisyUI components come with modifier class names and that modifier class name will apply a color." />

<Translate text="For example" />:

```html
<button class="btn btn-primary">Button</button>
```

<Translate text="Or" />:

```html
<input type="checkbox" class="checkbox checkbox-secondary" />
```

These components automatically set the correct background color, text color, border color, etc as needed so you don't need to set those colors manually. For example `btn-primary` sets `primary` color for background and border, and sets `primary-content` color for the text automatically as default. You can customize them using utility classes if you want to change the color.

<Translate text="You can also use color names in utility classes just like Tailwind's original color names." />
<Translate text="These are utility classes that can be used with a color name:" />

| CSS Class                  |                                                                                                                                |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `bg-{COLOR_NAME}`          | Also available on CDN [/colors/properties.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties.css)                   |
| `text-{COLOR_NAME}`        | Also available on CDN [/colors/properties.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties.css)                   |
| `border-{COLOR_NAME}`      | Also available on CDN [/colors/properties.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties.css)                   |
| `from-{COLOR_NAME}`        | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `via-{COLOR_NAME}`         | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `to-{COLOR_NAME}`          | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `ring-{COLOR_NAME}`        | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `fill-{COLOR_NAME}`        | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `stroke-{COLOR_NAME}`      | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `shadow-{COLOR_NAME}`      | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `outline-{COLOR_NAME}`     | Also available on CDN [/colors/properties-extended.css](https://cdn.jsdelivr.net/npm/daisyui@5/colors/properties-extended.css) |
| `divide-{COLOR_NAME}`      |                                                                                                                                |
| `accent-{COLOR_NAME}`      |                                                                                                                                |
| `caret-{COLOR_NAME}`       |                                                                                                                                |
| `decoration-{COLOR_NAME}`  |                                                                                                                                |
| `placeholder-{COLOR_NAME}` |                                                                                                                                |
| `ring-offset-{COLOR_NAME}` |                                                                                                                                |

So you can use `bg-primary`, `border-secondary`, etc. Read more about [daisyUI color utility classes](/docs/utilities/).

### Opacity values

You can also use opacity values with color names.

```html
<div class="bg-primary/50">Primary background with 50% opacity</div>
```

- If you're using daisyUI as a Tailwind CSS plugin, the number can be any value between 0 and 100.

- If you're using the daisyUI CDN file, only opacity values of 10, 20, 30, 40, 50, 60, 70, 80, 90 are available.

## Color opacity and muted colors

`base-content` is the text color of the page by default. It's a dark color on light themes and it's a light color on dark themes.

<div class="grid md:grid-cols-2 gap-10">
  <div class="relative bg-base-100 p-10 border border-base-content/10 rounded-box" data-theme="nord">
    <div class="badge badge-xs absolute end-2 top-2">nord theme</div>
    <div class="text-base-content">text-base-content</div>
  </div>
  <div class="relative bg-base-100 p-10 border border-base-content/10 rounded-box" data-theme="dracula">
    <div class="badge badge-xs absolute end-2 top-2">dracula theme</div>
    <div class="text-base-content">text-base-content</div>
  </div>
</div>

Sometimes we need a muted text. something with less contrast. The best way to do this is using Tailwind CSS color opacity modifier by adding a `/50` (or any other value) to the end of color name. Like `text-base-content/50`

<div class="grid md:grid-cols-2 gap-10">
  <div class="relative bg-base-100 p-10 border border-base-content/10 rounded-box" data-theme="nord">
    <div class="badge badge-xs absolute end-2 top-2">nord theme</div>
    <div class="text-base-content">text-base-content</div>
    <div class="text-base-content/70">text-base-content/70</div>
    <div class="text-base-content/50">text-base-content/50</div>
    <div class="text-base-content/30">text-base-content/30</div>
  </div>
  <div class="relative bg-base-100 p-10 border border-base-content/10 rounded-box" data-theme="dracula">
    <div class="badge badge-xs absolute end-2 top-2">dracula theme</div>
    <div class="text-base-content">text-base-content</div>
    <div class="text-base-content/70">text-base-content/70</div>
    <div class="text-base-content/50">text-base-content/50</div>
    <div class="text-base-content/30">text-base-content/30</div>
  </div>
</div>

The advantage of using opacity is that it gives a constant result on all themes, for all colors.  
You can use it with any opacity value, you can use it for any color. For example primary-content:

<div class="grid md:grid-cols-2 gap-10">
  <div class="relative bg-primary p-10 border border-primary-content/10 rounded-box" data-theme="nord">
    <div class="badge badge-xs absolute end-2 top-2">nord theme</div>
    <div class="text-primary-content">text-primary-content</div>
    <div class="text-primary-content/50">text-primary-content/50</div>
  </div>
  <div class="relative bg-primary p-10 border border-primary-content/10 rounded-box" data-theme="dracula">
    <div class="badge badge-xs absolute end-2 top-2">dracula theme</div>
    <div class="text-primary-content">text-primary-content</div>
    <div class="text-primary-content/50">text-primary-content/50</div>
  </div>
</div>

# UTILITIES

---
title: Utility classes and CSS variables
desc: daisyUI provides a few useful utility classes and CSS variables to help you use the library more effectively.
---

<script>
  import Translate from "$components/Translate.svelte"
</script>

## <Translate text="Color utility classes" />

All daisyUI colors can be used as utility classes. Just like any other Tailwind CSS color.  
For example you can use `primary` color with any of Tailwind CSS color utilities.

Read more about [color names](/docs/colors).

| Class Name            | Description                                                 |
| --------------------- | ----------------------------------------------------------- |
| `bg-primary`          | Sets the background color to the primary color              |
| `to-primary`          | Sets the ending color for a gradient to the primary color   |
| `via-primary`         | Sets the middle color for a gradient to the primary color   |
| `from-primary`        | Sets the starting color for a gradient to the primary color |
| `text-primary`        | Sets the text color to the primary color                    |
| `ring-primary`        | Sets the ring color to the primary color                    |
| `fill-primary`        | Sets the fill color for SVG elements to the primary color   |
| `caret-primary`       | Sets the caret color to the primary color                   |
| `stroke-primary`      | Sets the stroke color for SVG elements to the primary color |
| `border-primary`      | Sets the border color to the primary color                  |
| `divide-primary`      | Sets the color for dividing borders to the primary color    |
| `accent-primary`      | Sets the accent color to the primary color                  |
| `shadow-primary`      | Sets the shadow color to the primary color                  |
| `outline-primary`     | Sets the outline color to the primary color                 |
| `decoration-primary`  | Sets the text decoration color to the primary color         |
| `placeholder-primary` | Sets the placeholder text color to the primary color        |
| `ring-offset-primary` | Sets the ring offset color to the primary color             |

You can use `bg-primary` to set the background color to the primary color and `text-primary-content` to set the text color to the primary color.

```html
<div class="bg-primary text-primary-content">Primary color</div>
```

You can also control the opacity of the color like

```html
<div class="bg-primary text-primary-content/60">Primary-content color with 60% opacity</div>
```

## <Translate text="Border radius" />

Tailwind CSS provides fixed values for border radius, such as `rounded-sm`, `rounded-lg`, `rounded-xl`, etc.  
daisyUI provides a few more border radius values which are tokenized for components and can be customized based on the theme.

Change the theme to see the border radius changes:

<div class="grid sm:grid-cols-3 gap-4">
  <div class="grid place-content-center text-xs py-10 bg-base-content text-base-100 rounded-box">rounded-box</div>
  <div class="grid place-content-center text-xs py-10 bg-base-content text-base-100 rounded-field">rounded-field</div>
  <div class="grid place-content-center text-xs py-10 bg-base-content text-base-100 rounded-selector">rounded-selector</div>
</div>

| Class Name         | CSS Variable             | Description                                                       |
| ------------------ | ------------------------ | ----------------------------------------------------------------- |
| `rounded-box`      | `var(--radius-box)`      | For large sized components like card, modal, alert, etc.          |
| `rounded-field`    | `var(--radius-field)`    | For medium sized components like button, input, select, tab, etc. |
| `rounded-selector` | `var(--radius-selector)` | For small sized components like checkbox, toggle, badge, etc.     |

## <Translate text="Glass" />

`glass` creates a glass effect on the element.

<div class="rounded-box p-10 " style="background-image: url(https://img.daisyui.com/images/stock/photo-1507358522600-9f71e620c44e.webp);">
<div class="glass h-40 rounded-box grid place-content-center">Glass</div>
</div>

```html
<div class="glass">Glass</div>
```

## Theme CSS variables

These CSS variables can be customized for each themes. Read more about [color names](/docs/colors).

| CSS Variable                | Description                                                     |
| --------------------------- | --------------------------------------------------------------- |
| `--color-primary`           | Primary brand color                                             |
| `--color-primary-content`   | Foreground content color to use on primary color                |
| `--color-secondary`         | Secondary brand color                                           |
| `--color-secondary-content` | Foreground content color to use on secondary color              |
| `--color-accent`            | Accent brand color                                              |
| `--color-accent-content`    | Foreground content color to use on accent color                 |
| `--color-neutral`           | Neutral dark color                                              |
| `--color-neutral-content`   | Foreground content color to use on neutral color                |
| `--color-base-100`          | Base color of page, used for blank backgrounds                  |
| `--color-base-200`          | Base color, darker shade                                        |
| `--color-base-300`          | Base color, even more darker shade                              |
| `--color-base-content`      | Foreground content color to use on base color                   |
| `--color-info`              | Info color                                                      |
| `--color-info-content`      | Foreground content color to use on info color                   |
| `--color-success`           | Success color                                                   |
| `--color-success-content`   | Foreground content color to use on success color                |
| `--color-warning`           | Warning color                                                   |
| `--color-warning-content`   | Foreground content color to use on warning color                |
| `--color-error`             | Error color                                                     |
| `--color-error-content`     | Foreground content color to use on error color                  |
| `--radius-selector`         | Border radius for selectors like checkbox, toggle, badge, etc   |
| `--radius-field`            | Border radius for fields like input, select, tab, etc           |
| `--radius-box`              | Border radius for boxes like card, modal, alert, etc            |
| `--size-selector`           | Base scale size for selectors like checkbox, toggle, badge, etc |
| `--size-field`              | Base scale size for fields like input, select, tab, etc         |
| `--border`                  | Border width of all components                                  |
| `--depth`                   | (binary) Adds a depth effect for relevant components            |
| `--noise`                   | (binary) Adds a background noise effect for relevant components |

## <Translate text="Component specific CSS variables" />

For advanced use: These CSS variables are being used internally for a specific components. You probably won't need to customize them, but you can if you want to.

If you are using a prefix for daisyUI, these CSS variables will be prefixed with that prefix as well. For example if prefix is `daisy-`, The `--alert-color` CSS variable will be `--daisy-alert-color`.

> :INFO:
>
> These variables are for internal use. They are not subject of semantic versioning and some of them may be modified or removed in future minor versions, in which case your custom styles might lose their effect, so if you want to modify these variables and your UI really depends on the customized value, make sure you are using a fixed version of daisyUI, not the latest version.

| Component       | CSS Variable                  | Description                                              |
| --------------- | ----------------------------- | -------------------------------------------------------- |
| Alert           | `--alert-color`               | color of the alert                                       |
| Badge           | `--badge-color`               | color of the badge                                       |
|                 | `--size`                      | size of the badge                                        |
| Button          | `--btn-color`                 | background color of the button                           |
|                 | `--btn-fg`                    | foreground color of the button                           |
|                 | `--btn-shadow`                | shadow of the button                                     |
|                 | `--btn-noise`                 | noise background of the button if enabled                |
|                 | `--btn-p`                     | padding of the button                                    |
|                 | `--size`                      | size of the button                                       |
| Card            | `--card-p`                    | padding of the card body                                 |
|                 | `--card-fs`                   | font size of the card body                               |
|                 | `--cardtitle-fs`              | font size of the card title                              |
| Checkbox        | `--size`                      | size of the checkbox                                     |
| Countdown       | `--value`                     | value of the countdown                                   |
|                 | `--digits`                    | minimum number of digits for countdown                   |
| Divider         | `--divider-m`                 | margin of the divider                                    |
| Dropdown        | `--anchor-v`                  | vertical position of the anchor                          |
|                 | `--anchor-h`                  | horizontal position of the anchor                        |
| File input      | `--input-color`               | color of the file input                                  |
|                 | `--size`                      | size of the file input                                   |
| Hover 3D        | `--ease`                      | easing-animation                                         |
|                 | `--shadow`                    | underlying shadow effect                                 |
|                 | `--shine`                     | overlay shine effect                                     |
|                 | `--transform`                 | transform angle                                          |
| Hover Gallery   | `--items`                     | number of items                                          |
| Indicator       | `--indicator-t`               | top position of the indicator                            |
|                 | `--indicator-b`               | bottom position of the indicator                         |
|                 | `--indicator-s`               | start position of the indicator                          |
|                 | `--indicator-e`               | end position of the indicator                            |
|                 | `--indicator-y`               | vertical position of the indicator                       |
|                 | `--indicator-x`               | horizontal position of the indicator                     |
| Input           | `--input-color`               | color of the input                                       |
|                 | `--size`                      | size of the input                                        |
|                 | `--font-size`                 | font-size of the input                                   |
| Kbd             | `--size`                      | size of the kbd                                          |
| List            | `--list-grid-cols`            | grid columns of the list                                 |
| Menu            | `--menu-active-fg`            | foreground color of the active menu item                 |
|                 | `--menu-active-bg`            | background color of the active menu item                 |
| Modal           | `--modal-tl`                  | top left border radius of the modal                      |
|                 | `--modal-tr`                  | top right border radius of the modal                     |
|                 | `--modal-bl`                  | bottom left border radius of the modal                   |
|                 | `--modal-br`                  | bottom right border radius of the modal                  |
| Radial progress | `--value`                     | value of the radial progress                             |
|                 | `--size`                      | size of the radial progress                              |
|                 | `--thickness`                 | thickness of the radial progress                         |
|                 | `--radialprogress`            | for calculating the radial progress position             |
| Radio           | `--size`                      | size of the radio                                        |
| Range           | `--range-bg`                  | background color of the range slider thumb               |
|                 | `--range-thumb`               | color of the range slider thumb                          |
|                 | `--range-thumb-size`          | size of the range slider thumb                           |
|                 | `--range-progress`            | color of the range slider progress                       |
|                 | `--range-fill`                | binary, whether to fill the range slider progress or not |
|                 | `--range-p`                   | padding of the range slider thumb                        |
|                 | `--size`                      | size of the range slider                                 |
| Select          | `--input-color`               | color of the input                                       |
|                 | `--size`                      | size of the select                                       |
| Tab             | `--tabs-height`               | height of the tabs                                       |
|                 | `--tabs-direction`            | direction of the tabs                                    |
|                 | `--tab-p`                     | padding of the tab                                       |
|                 | `--tab-bg`                    | background color of the tab                              |
|                 | `--tab-border-color`          | border color of the tab                                  |
|                 | `--tab-radius-ss`             | start start border radius of the tab                     |
|                 | `--tab-radius-se`             | start end border radius of the tab                       |
|                 | `--tab-radius-es`             | end start border radius of the tab                       |
|                 | `--tab-radius-ee`             | end end border radius of the tab                         |
|                 | `--tab-order`                 | Order of the tab                                         |
|                 | `--tab-radius-min`            | minimum border radius of the lift tab                    |
|                 | `--tab-paddings`              | all padding values of the lift tab                       |
|                 | `--tab-border-colors`         | all border color values of the lift tab                  |
|                 | `--tab-corner-width`          | corner width of the lift tab                             |
|                 | `--tab-corner-height`         | corner height of the lift tab                            |
|                 | `--tab-corner-width`          | corner width of the lift tab                             |
|                 | `--tab-corner-position`       | corner position of the lift tab                          |
|                 | `--tab-inset`                 | inset position of the lift tab                           |
|                 | `--radius-start`              | border radius for the corner of the lift tab             |
|                 | `--radius-end`                | border radius for the corner of the lift tab             |
|                 | `--tabcontent-margin`         | margin of the tab content                                |
|                 | `--tabcontent-radius-ss`      | start start border radius of the tab content             |
|                 | `--tabcontent-radius-se`      | start end border radius of the tab content               |
|                 | `--tabcontent-radius-es`      | end start border radius of the tab content               |
|                 | `--tabcontent-radius-ee`      | end end border radius of the tab content                 |
|                 | `--tabcontent-order`          | order of the tab content                                 |
| Text Rotate     | `--items`                     | number of items                                          |
|                 | `--duration`                  | total duration of loop in milliseconds                   |
|                 | `--first-item-position`       | dynamic position of the first item                       |
| Textarea        | `--input-color`               | color of the input                                       |
|                 | `--size`                      | size of the textarea                                     |
|                 | `--font-size`                 | font-size of the textarea                                |
| Timeline        | `--timeline-row-start`        | start position of the timeline row                       |
|                 | `--timeline-row-end`          | end position of the timeline row                         |
|                 | `--timeline-col-start`        | start position of the timeline column                    |
|                 | `--timeline-col-end`          | end position of the timeline column                      |
| Toast           | `--toast-x`                   | horizontal position of the toast                         |
|                 | `--toast-y`                   | vertical position of the toast                           |
| Toggle          | `--toggle-p`                  | padding of the toggle                                    |
|                 | `--size`                      | size of the toggle                                       |
| Tooltip         | `--tt-bg`                     | background color of the tooltip                          |
|                 | `--tt-off`                    | offset of the tooltip                                    |
|                 | `--tt-tailw`                  | position of the tooltip tail                             |
| Glass           | `--glass-blur`                | blur of the glass effect                                 |
|                 | `--glass-opacity`             | opacity of the glass effect                              |
|                 | `--glass-reflect-degree`      | degree of the glass reflection                           |
|                 | `--glass-reflect-opacity`     | opacity of the glass reflection                          |
|                 | `--glass-border-opacity`      | opacity of the glass border                              |
|                 | `--glass-text-shadow-opacity` | opacity of the glass text shadow                         |
| Join            | `--join-ss`                   | start start border radius of the join                    |
|                 | `--join-se`                   | start end border radius of the join                      |
|                 | `--join-es`                   | end start border radius of the join                      |
|                 | `--join-ee`                   | end end border radius of the join                        |

### Examples of customizing component specific CSS variables

1. Customizing `--alert-color` using a utility class:

   ```html:html
   <div class="alert [--alert-color:blue]">
     <span>12 unread messages. Tap to see.</span>
   </div>
   ```

2. Customizing `--alert-color` from CSS:

   ```postcss:css
   @import "tailwindcss";
   @plugin "daisyui";

   .alert {
     --alert-color: blue;
   }
   ```

# COMPONENTS

- alert
- avatar
- badge
- breadcrumbs
- button
- calendar
- card
- carousel
- chat
- checkbox
- collapse
- countdown
- diff
- divider
- dock
- drawer
- dropdown
- fab
- fieldset
- fileinput
- filter
- footer
- hero
- hover3d
- hovergallery
- indicator
- input
- kbd
- label
- link
- list
- loading
- mask
- menu
- mockup
- modal
- navbar
- progress
- radialprogress
- radio
- range
- rating
- select
- skeleton
- stack
- stat
- status
- steps
- swap
- tab
- table
- textarea
- textrotate
- timeline
- toast
- toggle
- tooltip
- validator
