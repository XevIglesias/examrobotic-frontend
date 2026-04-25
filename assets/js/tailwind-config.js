tailwind.config = {
    theme: {
        extend: {
            fontFamily: {
                sans: ['Manrope', 'sans-serif'],
            },
            colors: {
                background: '#f9fafb',
                foreground: '#000000',
                primary:    '#2563eb',
                border:     '#e5e7eb',
                card:       '#ffffff',
                muted:      '#64748b',
            },
            boxShadow: {
                'card':       '0 2px 8px 0 rgba(11,32,64,0.07)',
                'card-hover': '0 8px 24px -4px rgba(11,32,64,0.13)',
            },
        },
    },
}
