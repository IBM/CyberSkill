DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    DECLARE @account_uuid UNIQUEIDENTIFIER = NEWID();
    DECLARE @user_uuid NVARCHAR(255) = CAST(NEWID() AS NVARCHAR(255));
    DECLARE @call_uuid UNIQUEIDENTIFIER = NEWID();
    DECLARE @product_uuid NVARCHAR(255) = CAST(NEWID() AS NVARCHAR(255));
    DECLARE @email_uuid NVARCHAR(255) = CAST(NEWID() AS NVARCHAR(255));
    DECLARE @template_uuid NVARCHAR(255) = CAST(NEWID() AS NVARCHAR(255));
    DECLARE @bug_uuid NVARCHAR(255) = CAST(NEWID() AS NVARCHAR(255));
    DECLARE @status_id INT = (@i % 4) + 1;

    INSERT INTO dbo.tbl_crm_accounts (id, name, date_entered, date_modified, modified_user_id, created_by,
                                      description, deleted, assigned_user_id, account_type, industry, annual_revenue,
                                      phone_fax, billing_address_street, billing_address_city, billing_address_state,
                                      billing_address_postalcode, billing_address_country, rating, phone_office,
                                      phone_alternate, website, ownership, employees, ticker_symbol,
                                      shipping_address_street, shipping_address_city, shipping_address_state,
                                      shipping_address_postalcode, shipping_address_country, parent_id, sic_code,
                                      campaign_id, status)
    VALUES (@account_uuid, 'Company ' + CAST(@i AS NVARCHAR), GETDATE(), GETDATE(), @user_uuid, @user_uuid,
            NULL, 0, @user_uuid, 'Customer', 'Technology', NULL, NULL, 'Street ' + CAST(@i AS NVARCHAR),
            'City ' + CAST(@i AS NVARCHAR), 'State ' + CAST(@i AS NVARCHAR), '100' + CAST(@i AS NVARCHAR),
            'Country ' + CAST(@i AS NVARCHAR), NULL, '(123) 456-789' + CAST(@i AS NVARCHAR), NULL,
            'www.company' + CAST(@i AS NVARCHAR) + '.com', NULL, NULL, NULL, 'Street ' + CAST(@i AS NVARCHAR),
            'City ' + CAST(@i AS NVARCHAR), 'State ' + CAST(@i AS NVARCHAR), '100' + CAST(@i AS NVARCHAR),
            'Country ' + CAST(@i AS NVARCHAR), NULL, NULL, NULL, @status_id);

    INSERT INTO dbo.tbl_calls (id, name, date_entered, date_modified, modified_user_id, created_by,
                               description, deleted, assigned_user_id, duration_hours, duration_minutes,
                               date_start, date_end, parent_type, status, direction, parent_id, reminder_time, outlook_id)
    VALUES (@call_uuid, 'Call ' + CAST(@i AS NVARCHAR), DATEADD(DAY,-2,GETDATE()), GETDATE(), @user_uuid, @user_uuid,
            NULL, 0, @user_uuid, 1, 30, GETDATE(), DATEADD(MINUTE,30,GETDATE()), 'Accounts', 'Planned', 'Outbound',
            @account_uuid, -1, NULL);

    INSERT INTO dbo.tbl_product (id, name, description, price, quantity)
    VALUES (@product_uuid, 'Product ' + CAST(@i AS NVARCHAR), 'Description for product ' + CAST(@i AS NVARCHAR), 9.99, 100);

    INSERT INTO dbo.tbl_email_lists (id, email_address, email_address_caps, opt_out, date_created)
    VALUES (@email_uuid, 'user' + CAST(@i AS NVARCHAR) + '@securecrm.com', 'USER' + CAST(@i AS NVARCHAR) + '@securecrm.COM', 0, GETDATE());

    INSERT INTO dbo.tbl_marketing_template (id, subject, body)
    VALUES (@template_uuid, 'Marketing Subject ' + CAST(@i AS NVARCHAR), 'Marketing body content for ' + CAST(@i AS NVARCHAR));

    INSERT INTO dbo.tbl_marketing_campaign (email_id, template_id, campaign_date)
    VALUES (@email_uuid, @template_uuid, DATEADD(DAY,10,GETDATE()));

    INSERT INTO dbo.tbl_bugs (id, name, date_entered, date_modified, modified_user_id, created_by,
                              description, deleted, assigned_user_id, bug_number, type, status, priority,
                              resolution, work_log, found_in_release, fixed_in_release, source, product_category)
    VALUES (@bug_uuid, 'Bug ' + CAST(@i AS NVARCHAR), DATEADD(DAY,-2,GETDATE()), GETDATE(), @user_uuid, @user_uuid,
            NULL, 0, @user_uuid, @i, NULL, 'Assigned', 'Medium', NULL, NULL, NULL, NULL, NULL, NULL);

    SET @i += 1;
END;
