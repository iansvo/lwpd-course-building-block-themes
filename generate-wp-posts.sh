#!/bin/bash

# WP-CLI Script to Generate Posts with Featured Images and Block Content
# Usage: ./generate-wp-posts.sh [number_of_posts]

# Number of posts to generate (default: 25)
NUM_POSTS=${1:-25}

# Array of sample titles
TITLES=(
    "The Future of Web Development"
    "Building Better WordPress Themes"
    "Understanding Modern JavaScript"
    "CSS Grid vs Flexbox: A Comparison"
    "Optimizing WordPress Performance"
    "The Rise of Headless CMS"
    "Accessibility Best Practices"
    "Mobile-First Design Principles"
    "Typography in Web Design"
    "Color Theory for Developers"
    "User Experience Fundamentals"
    "Progressive Web Apps Explained"
    "REST API Development Guide"
    "Security Best Practices"
    "Database Optimization Tips"
    "Version Control with Git"
    "Automated Testing Strategies"
    "Responsive Images Tutorial"
    "Web Animation Techniques"
    "Modern Build Tools"
    "Component-Based Architecture"
    "State Management Solutions"
    "Performance Monitoring"
    "SEO for Developers"
    "Content Strategy Basics"
    "Design Systems Overview"
    "Microservices Architecture"
    "Cloud Hosting Options"
    "DevOps Workflows"
    "Continuous Integration Setup"
)

# Arrays for content variation
PARAGRAPH_TEXTS=(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
    "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet."
    "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident."
    "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus."
    "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."
    "Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus."
)

SECTION_TITLES=(
    "Understanding the Fundamentals"
    "Key Concepts to Master"
    "Best Practices and Approaches"
    "Common Pitfalls to Avoid"
    "Advanced Techniques"
    "Real-World Applications"
    "Getting Started"
    "Tools and Resources"
    "Performance Considerations"
    "Implementation Strategies"
    "Testing and Optimization"
    "Future Trends"
)

LIST_ITEMS=(
    "Consider performance implications when making architectural decisions"
    "Always test across multiple browsers and devices for consistency"
    "Document your code thoroughly for future maintainability"
    "Implement proper error handling and logging mechanisms"
    "Follow established coding standards and best practices"
    "Optimize assets and resources for faster load times"
    "Ensure accessibility compliance throughout your application"
    "Use version control effectively to track changes"
    "Write comprehensive unit tests for critical functionality"
    "Monitor application performance in production environments"
    "Keep dependencies up to date and secure"
    "Implement proper security measures from the start"
)

QUOTES=(
    "The best code is no code at all. Every line of code you write is a liability.|Coding Philosophy"
    "Make it work, make it right, make it fast - in that order.|Development Wisdom"
    "Code is like humor. When you have to explain it, it's bad.|Clean Code Principle"
    "First, solve the problem. Then, write the code.|Problem Solving"
    "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.|Martin Fowler"
    "Programs must be written for people to read, and only incidentally for machines to execute.|Structure and Interpretation"
)

# Function to download and import an image for inline use
download_inline_image() {
    local post_id=$1
    local img_num=$2
    local width=$((600 + RANDOM % 400))  # 600-1000px
    local height=$((width * 2 / 3))
    
    local temp_image="/tmp/inline-image-$post_id-$img_num.jpg"
    curl -s -L "https://picsum.photos/$width/$height" -o "$temp_image"
    
    if [ -f "$temp_image" ]; then
        local attachment_id=$(wp media import "$temp_image" \
            --post_id="$post_id" \
            --title="Content Image $img_num" \
            --porcelain 2>/dev/null)
        rm -f "$temp_image"
        echo "$attachment_id"
    else
        echo ""
    fi
}

# Function to generate random block content
generate_block_content() {
    local post_id=$1
    local content=""
    local num_sections=$((2 + RANDOM % 4))  # 2-5 sections
    
    for ((i=1; i<=num_sections; i++)); do
        # Add heading with random title
        local section_title="${SECTION_TITLES[$((RANDOM % ${#SECTION_TITLES[@]}))]}"
        content+="<!-- wp:heading -->\n"
        content+="<h2 class=\"wp-block-heading\">$section_title</h2>\n"
        content+="<!-- /wp:heading -->\n\n"
        
        # Add 1-3 paragraphs with varied text
        local num_paragraphs=$((1 + RANDOM % 3))
        for ((j=1; j<=num_paragraphs; j++)); do
            local para_text="${PARAGRAPH_TEXTS[$((RANDOM % ${#PARAGRAPH_TEXTS[@]}))]}"
            content+="<!-- wp:paragraph -->\n"
            content+="<p>$para_text</p>\n"
            content+="<!-- /wp:paragraph -->\n\n"
        done
        
        # Randomly add an image (40% chance)
        if [ $((RANDOM % 10)) -lt 4 ]; then
            local img_id=$(download_inline_image "$post_id" "$i")
            if [ -n "$img_id" ]; then
                local img_url=$(wp post list --post_type=attachment --p="$img_id" --field=guid 2>/dev/null)
                content+="<!-- wp:image {\"id\":$img_id,\"sizeSlug\":\"large\",\"linkDestination\":\"none\"} -->\n"
                content+="<figure class=\"wp-block-image size-large\"><img src=\"$img_url\" alt=\"\" class=\"wp-image-$img_id\"/></figure>\n"
                content+="<!-- /wp:image -->\n\n"
            fi
        fi
        
        # Randomly add a list (40% chance)
        if [ $((RANDOM % 10)) -lt 4 ]; then
            content+="<!-- wp:list -->\n"
            content+="<ul class=\"wp-block-list\">\n"
            # Add 3-5 random list items
            local num_items=$((3 + RANDOM % 3))
            for ((k=1; k<=num_items; k++)); do
                local list_item="${LIST_ITEMS[$((RANDOM % ${#LIST_ITEMS[@]}))]}"
                content+="<li>$list_item</li>\n"
            done
            content+="</ul>\n"
            content+="<!-- /wp:list -->\n\n"
        fi
        
        # Randomly add a quote (25% chance)
        if [ $((RANDOM % 10)) -lt 3 ]; then
            local quote_data="${QUOTES[$((RANDOM % ${#QUOTES[@]}))]}"
            local quote_text=$(echo "$quote_data" | cut -d'|' -f1)
            local quote_cite=$(echo "$quote_data" | cut -d'|' -f2)
            content+="<!-- wp:quote -->\n"
            content+="<blockquote class=\"wp-block-quote\"><p>$quote_text</p><cite>$quote_cite</cite></blockquote>\n"
            content+="<!-- /wp:quote -->\n\n"
        fi
        
        # Add another paragraph after some blocks (50% chance)
        if [ $((RANDOM % 2)) -eq 0 ]; then
            local para_text="${PARAGRAPH_TEXTS[$((RANDOM % ${#PARAGRAPH_TEXTS[@]}))]}"
            content+="<!-- wp:paragraph -->\n"
            content+="<p>$para_text</p>\n"
            content+="<!-- /wp:paragraph -->\n\n"
        fi
    done
    
    echo -e "$content"
}

echo "Generating $NUM_POSTS posts with featured images and block content..."
echo "This may take a few minutes..."
echo ""

for ((i=1; i<=NUM_POSTS; i++)); do
    # Get random title from array
    TITLE="${TITLES[$((RANDOM % ${#TITLES[@]}))]}"
    
    # Create the post first (without content) so we have a post_id
    POST_ID=$(wp post create \
        --post_title="$TITLE" \
        --post_content="Generating content..." \
        --post_status=publish \
        --post_type=post \
        --porcelain)
    
    if [ $? -eq 0 ]; then
        echo "[$i/$NUM_POSTS] Created post ID: $POST_ID - \"$TITLE\""
        
        # Generate block content now that we have a post_id
        echo "    → Generating content with blocks and images..."
        CONTENT=$(generate_block_content "$POST_ID")
        
        # Update the post with the generated content
        wp post update "$POST_ID" --post_content="$CONTENT" >/dev/null 2>&1
        
        # Generate random image dimensions (keeping aspect ratio)
        WIDTH=$((800 + RANDOM % 400))  # 800-1200px
        HEIGHT=$((WIDTH * 2 / 3))       # Maintain ~3:2 aspect ratio
        
        # Download image from picsum.photos
        IMAGE_URL="https://picsum.photos/$WIDTH/$HEIGHT"
        TEMP_IMAGE="/tmp/featured-image-$POST_ID.jpg"
        
        # Download the image
        curl -s -L "$IMAGE_URL" -o "$TEMP_IMAGE"
        
        if [ -f "$TEMP_IMAGE" ]; then
            # Import to media library
            ATTACHMENT_ID=$(wp media import "$TEMP_IMAGE" \
                --post_id="$POST_ID" \
                --title="Featured Image for Post $POST_ID" \
                --porcelain 2>/dev/null)
            
            if [ $? -eq 0 ]; then
                # Set as featured image
                wp post meta update "$POST_ID" _thumbnail_id "$ATTACHMENT_ID" >/dev/null 2>&1
                echo "    ✓ Featured image set (${WIDTH}x${HEIGHT}px) + inline images added"
            else
                echo "    ✗ Failed to import featured image"
            fi
            
            # Clean up temp file
            rm -f "$TEMP_IMAGE"
        else
            echo "    ✗ Failed to download featured image"
        fi
        
        echo ""
    else
        echo "[$i/$NUM_POSTS] Failed to create post"
        echo ""
    fi
    
    # Small delay to avoid hammering picsum.photos
    sleep 0.5
done

echo "================================"
echo "Post generation complete!"
echo "Created $NUM_POSTS posts with featured images, inline images, and varied block content."
echo ""
echo "View your posts:"
echo "wp post list --post_type=post --orderby=date --order=DESC"
