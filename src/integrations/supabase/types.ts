export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      appellations: {
        Row: {
          country_id: string | null
          created_at: string
          id: string
          level: string
          name: string
          region_id: string | null
          sort_order: number
          sub_region_id: string | null
          type: string | null
          updated_at: string
        }
        Insert: {
          country_id?: string | null
          created_at?: string
          id?: string
          level: string
          name: string
          region_id?: string | null
          sort_order?: number
          sub_region_id?: string | null
          type?: string | null
          updated_at?: string
        }
        Update: {
          country_id?: string | null
          created_at?: string
          id?: string
          level?: string
          name?: string
          region_id?: string | null
          sort_order?: number
          sub_region_id?: string | null
          type?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "appellations_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "countries"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "appellations_region_id_fkey"
            columns: ["region_id"]
            isOneToOne: false
            referencedRelation: "regions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "appellations_sub_region_id_fkey"
            columns: ["sub_region_id"]
            isOneToOne: false
            referencedRelation: "sub_regions"
            referencedColumns: ["id"]
          },
        ]
      }
      cellar_members: {
        Row: {
          cellar_id: string
          created_at: string
          role: string
          user_id: string
        }
        Insert: {
          cellar_id: string
          created_at?: string
          role?: string
          user_id: string
        }
        Update: {
          cellar_id?: string
          created_at?: string
          role?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "cellar_members_cellar_id_fkey"
            columns: ["cellar_id"]
            isOneToOne: false
            referencedRelation: "cellars"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "cellar_members_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      cellars: {
        Row: {
          created_at: string
          created_by: string | null
          id: string
          invite_code: string
          name: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          id?: string
          invite_code?: string
          name: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          created_by?: string | null
          id?: string
          invite_code?: string
          name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "cellars_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      countries: {
        Row: {
          code: string | null
          continent: string | null
          created_at: string
          id: string
          name: string
          sort_order: number
          updated_at: string
        }
        Insert: {
          code?: string | null
          continent?: string | null
          created_at?: string
          id?: string
          name: string
          sort_order?: number
          updated_at?: string
        }
        Update: {
          code?: string | null
          continent?: string | null
          created_at?: string
          id?: string
          name?: string
          sort_order?: number
          updated_at?: string
        }
        Relationships: []
      }
      drinking_log: {
        Row: {
          cellar_id: string
          created_at: string
          date: string
          id: string
          note: string | null
          opened_by: string | null
          rating: number | null
          wine_id: string | null
          wine_label: string | null
        }
        Insert: {
          cellar_id: string
          created_at?: string
          date?: string
          id?: string
          note?: string | null
          opened_by?: string | null
          rating?: number | null
          wine_id?: string | null
          wine_label?: string | null
        }
        Update: {
          cellar_id?: string
          created_at?: string
          date?: string
          id?: string
          note?: string | null
          opened_by?: string | null
          rating?: number | null
          wine_id?: string | null
          wine_label?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "drinking_log_cellar_id_fkey"
            columns: ["cellar_id"]
            isOneToOne: false
            referencedRelation: "cellars"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "drinking_log_opened_by_fkey"
            columns: ["opened_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "drinking_log_wine_id_fkey"
            columns: ["wine_id"]
            isOneToOne: false
            referencedRelation: "wines"
            referencedColumns: ["id"]
          },
        ]
      }
      drinking_log_people: {
        Row: {
          log_id: string
          person_id: string
        }
        Insert: {
          log_id: string
          person_id: string
        }
        Update: {
          log_id?: string
          person_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "drinking_log_people_log_id_fkey"
            columns: ["log_id"]
            isOneToOne: false
            referencedRelation: "drinking_log"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "drinking_log_people_person_id_fkey"
            columns: ["person_id"]
            isOneToOne: false
            referencedRelation: "people"
            referencedColumns: ["id"]
          },
        ]
      }
      people: {
        Row: {
          avatar: string | null
          cellar_id: string
          created_at: string
          id: string
          name: string
        }
        Insert: {
          avatar?: string | null
          cellar_id: string
          created_at?: string
          id?: string
          name: string
        }
        Update: {
          avatar?: string | null
          cellar_id?: string
          created_at?: string
          id?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "people_cellar_id_fkey"
            columns: ["cellar_id"]
            isOneToOne: false
            referencedRelation: "cellars"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          created_at: string
          display_name: string | null
          email: string | null
          id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          display_name?: string | null
          email?: string | null
          id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          display_name?: string | null
          email?: string | null
          id?: string
          updated_at?: string
        }
        Relationships: []
      }
      regions: {
        Row: {
          country_id: string
          created_at: string
          id: string
          name: string
          sort_order: number
          updated_at: string
        }
        Insert: {
          country_id: string
          created_at?: string
          id?: string
          name: string
          sort_order?: number
          updated_at?: string
        }
        Update: {
          country_id?: string
          created_at?: string
          id?: string
          name?: string
          sort_order?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "regions_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "countries"
            referencedColumns: ["id"]
          },
        ]
      }
      sub_regions: {
        Row: {
          created_at: string
          id: string
          name: string
          region_id: string
          sort_order: number
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          name: string
          region_id: string
          sort_order?: number
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          name?: string
          region_id?: string
          sort_order?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "sub_regions_region_id_fkey"
            columns: ["region_id"]
            isOneToOne: false
            referencedRelation: "regions"
            referencedColumns: ["id"]
          },
        ]
      }
      wine_colours: {
        Row: {
          cellar_id: string
          created_at: string
          display_name: string
          id: string
          kind: string
          name: string
          sort_order: number
          updated_at: string
        }
        Insert: {
          cellar_id: string
          created_at?: string
          display_name: string
          id?: string
          kind?: string
          name: string
          sort_order?: number
          updated_at?: string
        }
        Update: {
          cellar_id?: string
          created_at?: string
          display_name?: string
          id?: string
          kind?: string
          name?: string
          sort_order?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "wine_colours_cellar_id_fkey"
            columns: ["cellar_id"]
            isOneToOne: false
            referencedRelation: "cellars"
            referencedColumns: ["id"]
          },
        ]
      }
      wines: {
        Row: {
          aging_indication: string | null
          alcohol_pct: number | null
          appellation_id: string | null
          base_vintage: number | null
          cellar_id: string
          classification: string | null
          colour_id: string | null
          country_id: string | null
          created_at: string
          created_by: string | null
          disgorgement_date: string | null
          dosage_gl: number | null
          dosage_level: string | null
          drink_by: number | null
          id: string
          is_non_vintage: boolean
          label_photo_path: string | null
          location: string | null
          name: string | null
          notes: string | null
          occasion: string | null
          price_chf: number | null
          producer: string | null
          purchased_from: string | null
          quantity: number
          rating: number | null
          ready_from: number | null
          region_id: string | null
          residual_sugar_gl: number | null
          size_ml: number | null
          storage_location: string | null
          sub_region_id: string | null
          terroir_notes: string | null
          tirage_date: string | null
          updated_at: string
          variety: string | null
          vintage: number | null
        }
        Insert: {
          aging_indication?: string | null
          alcohol_pct?: number | null
          appellation_id?: string | null
          base_vintage?: number | null
          cellar_id: string
          classification?: string | null
          colour_id?: string | null
          country_id?: string | null
          created_at?: string
          created_by?: string | null
          disgorgement_date?: string | null
          dosage_gl?: number | null
          dosage_level?: string | null
          drink_by?: number | null
          id?: string
          is_non_vintage?: boolean
          label_photo_path?: string | null
          location?: string | null
          name?: string | null
          notes?: string | null
          occasion?: string | null
          price_chf?: number | null
          producer?: string | null
          purchased_from?: string | null
          quantity?: number
          rating?: number | null
          ready_from?: number | null
          region_id?: string | null
          residual_sugar_gl?: number | null
          size_ml?: number | null
          storage_location?: string | null
          sub_region_id?: string | null
          terroir_notes?: string | null
          tirage_date?: string | null
          updated_at?: string
          variety?: string | null
          vintage?: number | null
        }
        Update: {
          aging_indication?: string | null
          alcohol_pct?: number | null
          appellation_id?: string | null
          base_vintage?: number | null
          cellar_id?: string
          classification?: string | null
          colour_id?: string | null
          country_id?: string | null
          created_at?: string
          created_by?: string | null
          disgorgement_date?: string | null
          dosage_gl?: number | null
          dosage_level?: string | null
          drink_by?: number | null
          id?: string
          is_non_vintage?: boolean
          label_photo_path?: string | null
          location?: string | null
          name?: string | null
          notes?: string | null
          occasion?: string | null
          price_chf?: number | null
          producer?: string | null
          purchased_from?: string | null
          quantity?: number
          rating?: number | null
          ready_from?: number | null
          region_id?: string | null
          residual_sugar_gl?: number | null
          size_ml?: number | null
          storage_location?: string | null
          sub_region_id?: string | null
          terroir_notes?: string | null
          tirage_date?: string | null
          updated_at?: string
          variety?: string | null
          vintage?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "wines_appellation_id_fkey"
            columns: ["appellation_id"]
            isOneToOne: false
            referencedRelation: "appellations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wines_cellar_id_fkey"
            columns: ["cellar_id"]
            isOneToOne: false
            referencedRelation: "cellars"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wines_colour_id_fkey"
            columns: ["colour_id"]
            isOneToOne: false
            referencedRelation: "wine_colours"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wines_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "countries"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wines_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wines_region_id_fkey"
            columns: ["region_id"]
            isOneToOne: false
            referencedRelation: "regions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "wines_sub_region_id_fkey"
            columns: ["sub_region_id"]
            isOneToOne: false
            referencedRelation: "sub_regions"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      create_cellar: { Args: { p_name: string }; Returns: string }
      current_cellar_id: { Args: never; Returns: string }
      current_member_role: { Args: never; Returns: string }
      generate_invite_code: { Args: never; Returns: string }
      join_cellar: { Args: { p_invite_code: string }; Returns: string }
      regenerate_invite_code: { Args: never; Returns: string }
      reorder_rows: {
        Args: { p_ids: string[]; p_table: string }
        Returns: undefined
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const

