table! {
    comment_votes (id) {
        id -> Integer,
        status -> Varchar,
        last_updated -> Timestamp,
        #[sql_name = "type"]
        type_ -> Nullable<Integer>,
        value -> Integer,
        comment_fk -> Integer,
    }
}

table! {
    comments (id) {
        id -> Integer,
        content -> Longtext,
        createdDate -> Timestamp,
        updateDate -> Timestamp,
        isAnonymized -> Nullable<Bool>,
        isDistinguished -> Bool,
        FormattedContent -> Nullable<Longtext>,
        parentId -> Integer,
        username -> Varchar,
        status -> Text,
        post_fk -> Integer,
    }
}

table! {
    posts (id) {
        id -> Integer,
        parent_id -> Nullable<Integer>,
        #[sql_name = "type"]
        type_ -> Nullable<Integer>,
        score -> Integer,
        community -> Nullable<Integer>,
        title -> Varchar,
        subTitle -> Nullable<Varchar>,
        thumbNailImage -> Nullable<Varchar>,
        createdDate -> Timestamp,
        updateDate -> Timestamp,
        status -> Enum,
        summary -> Nullable<Varchar>,
        author -> Varchar,
        contentLocation -> Varchar,
    }
}

table! {
    posts_type (id) {
        id -> Integer,
        name -> Varchar,
    }
}

table! {
    profile (username) {
        username -> Varchar,
        bio -> Nullable<Text>,
        vanityTitle -> Nullable<Varchar>,
        avatar -> Nullable<Text>,
        job_title -> Text,
        company -> Text,
        tags -> Nullable<Integer>,
    }
}

table! {
    tags (id) {
        id -> Integer,
        name -> Varchar,
    }
}

table! {
    themes (id) {
        id -> Integer,
        name -> Text,
    }
}

table! {
    user (username) {
        username -> Varchar,
    }
}

table! {
    userPreferences (username) {
        username -> Varchar,
        language -> Varchar,
        openInNewWindow -> Bool,
        displayAds -> Bool,
        collapseCommentLimit -> Nullable<Integer>,
        CommentSort -> Enum,
        displayThumbnails -> Bool,
        theme -> Integer,
        blockAnonymized -> Enum,
    }
}

table! {
    vote_types (id) {
        id -> Integer,
        name -> Varchar,
        last_updated -> Timestamp,
    }
}

table! {
    votes (id) {
        id -> Integer,
        status -> Varchar,
        last_updated -> Timestamp,
        #[sql_name = "type"]
        type_ -> Nullable<Integer>,
        value -> Integer,
        post_id -> Integer,
        content -> Nullable<Mediumtext>,
    }
}

joinable!(comment_votes -> comments (comment_fk));
joinable!(comment_votes -> vote_types (type));
joinable!(comments -> posts (post_fk));
joinable!(comments -> profile (username));
joinable!(posts -> posts_type (type));
joinable!(posts -> profile (author));
joinable!(profile -> tags (tags));
joinable!(profile -> user (username));
joinable!(userPreferences -> themes (theme));
joinable!(userPreferences -> user (username));
joinable!(votes -> posts (post_id));
joinable!(votes -> vote_types (type));

allow_tables_to_appear_in_same_query!(
    comment_votes,
    comments,
    posts,
    posts_type,
    profile,
    tags,
    themes,
    user,
    userPreferences,
    vote_types,
    votes,
);
